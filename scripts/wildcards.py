import math
import os
import pathlib
import sys
import traceback
import random
import re
from typing import Set

import modules.scripts as scripts
import modules.images as images
import gradio as gr

from modules.processing import Processed, process_images
from PIL import Image
from modules.shared import opts, cmd_opts, state


class Script(scripts.Script):
    def title(self):
        return "Wildcards"

    def ui(self, is_img2img):
        same_seed = gr.Checkbox(label='Use same seed for each image', value=False)

        return [same_seed]

    def run(self, p, same_seed):
        def replace_wildcard(chunk):
            chunk = chunk.replace("__", "")
            if " " not in chunk:
                file_dir = os.path.dirname(os.path.realpath("__file__"))
                wildcards_dir = os.path.join(file_dir, "scripts", "wildcards")
                # print(f"Wildcards dir: {wildcards_dir}")
                txt_files = list(pathlib.Path(wildcards_dir).rglob("*.txt"))
                # print(f"Text files: {txt_files}")

                replacement_files = []
                for path in txt_files:
                    if chunk in str(path.absolute()) or os.path.normpath(chunk) in str(path.absolute()):
                        replacement_files.append(str(path.absolute()))
                    else:
                        if "*" in chunk:
                            terms = [m for m in chunk.__str__().split("*")]
                            matched_terms = []
                            for term in terms:
                                if term in str(path.absolute()) or os.path.normpath(term) in str(path.absolute()):
                                    matched_terms.append(term)
                            if len(terms) == len(matched_terms):
                                replacement_files.append(str(path.absolute()))
                if len(replacement_files) == 0:
                    return chunk
                # print(f"Replacement files: {replacement_files}")
                contents: Set = set()
                for replacement_file in replacement_files:
                    if os.path.exists(replacement_file):
                        with open(replacement_file, encoding="utf8") as f:
                            lines = f.read().splitlines()
                            filtered = [line for line in lines if not line.startswith(
                                '#') and line is not None and len(line) > 0]
                            contents.update(filtered)
                contents_list = list(contents)
                # print(f"Possible choices: {contents_list}")
                for _ in range(0, p.n_iter):
                    # print("Picking random item from contents")
                    choice = random.choice(contents_list).strip()
                    print(f"Choice: {choice}")
                    return choice
            return chunk
        
        original_prompt = p.prompt[0] if type(p.prompt) == list else p.prompt
        all_prompts = ["".join(replace_wildcard(chunk) for chunk in original_prompt.split(",")) for _ in range(p.batch_size * p.n_iter)]

        # TODO: Pregenerate seeds to prevent overlaps when batch_size is > 1
        # Known issue: Clicking "recycle seed" on an image in a batch_size > 1 may not get the correct seed.
        # (unclear if this is an issue with this script or not, but pregenerating would prevent). However,
        # filename and exif data on individual images match correct seeds (testable via sending png info to txt2img).
        all_seeds = []
        infotexts = []

        initial_seed = None
        initial_info = None

        print(f"Will process {p.batch_size * p.n_iter} images in {p.n_iter} batches.")

        state.job_count = p.n_iter
        p.n_iter = 1

        original_do_not_save_grid = p.do_not_save_grid

        p.do_not_save_grid = True

        output_images = []
        for batch_no in range(state.job_count):
            state.job = f"{batch_no+1} out of {state.job_count}"
            p.prompt = all_prompts[batch_no*p.batch_size:(batch_no+1)*p.batch_size]
            if cmd_opts.enable_console_prompts:
                print(f"wildcards.py: {p.prompt}")
            proc = process_images(p)
            output_images += proc.images
            # TODO: Also add wildcard data to exif of individual images, currently only appear on the saved grid.
            infotext = "Wildcard prompt: "+original_prompt+"\nExample: "+proc.info
            all_seeds.append(proc.seed)
            infotexts.append(infotext)
            if initial_seed is None:
                initial_info = infotext
                initial_seed = proc.seed
            if not same_seed:
                p.seed = proc.seed+1

        p.do_not_save_grid = original_do_not_save_grid

        unwanted_grid_because_of_img_count = len(output_images) < 2 and opts.grid_only_if_multiple
        if (opts.return_grid or opts.grid_save) and not p.do_not_save_grid and not unwanted_grid_because_of_img_count:
            grid = images.image_grid(output_images, p.batch_size)

            if opts.return_grid:
                infotexts.insert(0, initial_info)
                all_seeds.insert(0, initial_seed)
                output_images.insert(0, grid)

            if opts.grid_save:
                images.save_image(grid, p.outpath_grids, "grid", all_seeds[0], original_prompt, opts.grid_format, info=initial_info, short_filename=not opts.grid_extended_filename, p=p, grid=True)

        return Processed(p, output_images, initial_seed, initial_info, all_prompts=all_prompts, all_seeds=all_seeds, infotexts=infotexts, index_of_first_image=0)

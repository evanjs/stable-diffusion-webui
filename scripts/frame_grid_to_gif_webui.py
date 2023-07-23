import modules.scripts as scripts
import gradio as gr
import os
import uuid 

from PIL import Image
from modules.processing import process_images, Processed, fix_seed
from modules.shared import opts, cmd_opts, state

def make_gif(frames, frame_duration = 100, filename = None):
    if filename is None:
      filename = str(uuid.uuid4())

    outpath = "outputs/txt2img-images/txt2gif"
    if not os.path.exists(outpath):
        os.makedirs(outpath)

    first_frame, append_frames = frames[0], frames[1:]

    filename = f"{outpath}/{filename}.gif"

    first_frame.save(filename, format="GIF", append_images=append_frames,
               save_all=True, duration=frame_duration, loop=0)

    return first_frame, filename

def cut_frames_from_grid(imgs, grid_x, grid_y, frame_duration):
  frame_list = []
  for img in imgs:
    img_width, img_height = img.size
    frame_width = img_width // grid_x
    frame_height = img_height // grid_y

    frames = []

    for y in range(grid_y):
        for x in range(grid_x):
            frame = img.crop((x * frame_width, y * frame_height, (x + 1) * frame_width, (y + 1) * frame_height))
            frames.append(frame)

    frame_list.append(frames)
  return frame_list

def main(p, grid_x, grid_y, frame_duration):
  proc = process_images(p)

  frames_list = cut_frames_from_grid(proc.images, int(grid_x), int(grid_y), frame_duration)

  gifs = []
  gif_paths = []
  for frames in frames_list:
    gif_image, gif_path = make_gif(frames)
    gifs.append(gif_image)
    gif_paths.append(gif_path)

  return Processed(p, gifs, p.seed, "", all_prompts=proc.all_prompts, infotexts=proc.infotexts)

class Script(scripts.Script):
    is_txt2img = False

    # Function to set title
    def title(self):
        return "frame grid to gif"

    def ui(self, is_img2img):
        with gr.Row():
          grid_x = gr.Number(label="grid_x", value = 3.0)
          grid_y = gr.Number(label="grid_y", value = 3.0)
          frame_duration = gr.Number(label="frame_duration", value = 100.0)

        return [grid_x, grid_y, frame_duration]

    # Function to show the script
    def show(self, is_img2img):
        return True

    # Function to run the script
    def run(self, p, grid_x, grid_y, frame_duration):
        # Make a process_images Object
        return main(p, grid_x, grid_y, frame_duration)

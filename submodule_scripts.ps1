New-Item -Type SymbolicLink -Force -Target ../external/advanced-prompt-matrix/scripts/advanced_prompt_matrix.py -Path ./scripts/advanced_prompt_matrix.py
New-Item -Type SymbolicLink -Force -Target ../external/amotile/src/process/implementations/automatic1111_scripts/advanced_seed_blending.py -Path ./scripts/advanced_seed_blending.py
New-Item -Type SymbolicLink -Force -Target ../external/amotile/src/process/implementations/automatic1111_scripts/prompt_blending.py -Path ./scripts/prompt_blending.py
New-Item -Type SymbolicLink -Force -Target ../external/animator/animation_v4.py -Path ./scripts/animator.py
New-Item -Type SymbolicLink -Force -Target ../external/loopback_superimpose/loopback_superimpose.py -Path ./scripts/loopback_superimpose.py
New-Item -Type SymbolicLink -Force -Target ../external/seed_travel/scripts/seed_travel.py -Path ./scripts/seed_travel.py
New-Item -Type SymbolicLink -Force -Target ../external/shift-attention/scripts/shift_attention.py -Path ./scripts/shift_attention.py
New-Item -Type SymbolicLink -Force -Target ../external/stable-diffusion-webui-cv2-external-masking-script/external_masking.py -Path ./scripts/external_masking.py
New-Item -Type SymbolicLink -Force -Target ../external/stable-diffusion-webui-video/videos.py -Path ./scripts/videos.py
New-Item -Type SymbolicLink -Force -Target ../external/txt2mask/scripts/txt2mask.py -Path ./scripts/txt2mask.py
New-Item -Type SymbolicLink -Force -Target ../external/txt2vectorgraphics/txt2vectorgfx.py -Path ./scripts/txt2vectorgfx.py
New-Item -Type SymbolicLink -Force -Target ../external/vid2vid/scripts/vid2vid.py -Path ./scripts/vid2vid.py

New-Item -Type SymbolicLink -Force -Target ../external/txt2img2img/scripts/txt2img2img.py -Path ./scripts/txt2img2img.py
New-Item -Type SymbolicLink -Force -Target ./external/txt2img2img/txt2img2img -Path txt2img2img

#New-Item -Type Junction -Target $PWD/external/dynamic_prompting -Path $PWD/extensions/dynamic_prompting -ErrorAction SilentlyContinue
New-Item -Type Junction -Target $PWD/external/sd-dynamic-prompts -Path ./extensions/sd-dynamic-prompts -ErrorAction SilentlyContinue

New-Item -Type Junction -Target $PWD/external/boorucomplete/ -Path ./extensions/boorucomplete -ErrorAction SilentlyContinue
New-Item -Type Junction -Target $PWD/external/boorucomplete/tags/ -Path ./tags -ErrorAction SilentlyContinue

New-Item -Type Junction -Target $PWD/external/images-browser ./extensions/images-browser -ErrorAction SilentlyContinue
New-Item -Type Junction -Target $PWD/external/aesthetic-gradients ./extensions/aesthetic-gradients -ErrorAction SilentlyContinue

New-Item -Type SymbolicLink -Force -Target ../external/sdexperiments/outpaint_region.py -Path ./scripts/outpaint_region.py

New-Item -Type SymbolicLink -Force -Target ../external/StylePile/StylePile.py -Path ./scripts/StylePile.py
New-Item -Type Junction -Target $PWD/external/StylePile/StylePile -Path ./scripts/StylePile -ErrorAction SilentlyContinue

New-Item -Type Junction -Target $PWD/external/novelai-2-local-prompt ./extensions/novelai-2-local-prompt -ErrorAction SilentlyContinue

# Incompatible with `a1111-sd-webui-tagcomplete`
# Any files accessed by Gradio need to exist under the root of the application
#New-Item -Type Junction -Target "$((Get-Location).Path)/../../external/stable-diffusion/wildcards/" -Path "./scripts/wildcards" -ErrorAction SilentlyContinue

# Instead of creating a symlink to files that exist outside of the repository,
# copy external wildcards into a directory under the application root 
Copy-Item -Force -Recurse -Path $PWD/../../external/stable-diffusion/wildcards/* -Destination wildcards_here -ErrorAction SilentlyContinue

# Recurse through files in the wildcards directory and set them to read only
# This will help ensure we don't make updates to the wildcards in the application root
# and later overwrite with changes via this script
# Get-ChildItem -File ./external/UnivAICharGen/wildcards/mine -Recurse |
    # Set-ItemProperty -Name IsReadOnly -Value $false

#Copy-Item -Force -Recurse -Path wildcards_here/* -Path extensions/UnivAICharGen/wildcards/ -ErrorAction SilentlyContinue
New-Item -Type Junction -Target $PWD/wildcards_here -Path $PWD/extensions/UnivAICharGen/wildcards/mine -ErrorAction SilentlyContinue

New-Item -Type Junction -Target $PWD/wildcards_here -Path $PWD/extensions/wildcards -ErrorAction SilentlyContinue
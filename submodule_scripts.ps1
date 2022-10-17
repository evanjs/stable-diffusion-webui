New-Item -Type SymbolicLink -Force -Target ../external/advanced-prompt-matrix/scripts/advanced_prompt_matrix.py -Path ./scripts/advanced_prompt_matrix.py
New-Item -Type SymbolicLink -Force -Target ../external/amotile/src/process/implementations/automatic1111_scripts/advanced_seed_blending.py -Path ./scripts/advanced_seed_blending.py
New-Item -Type SymbolicLink -Force -Target ../external/amotile/src/process/implementations/automatic1111_scripts/prompt_blending.py -Path ./scripts/prompt_blending.py
New-Item -Type SymbolicLink -Force -Target ../external/animator/scripts/animator.py -Path ./scripts/animator.py
New-Item -Type SymbolicLink -Force -Target ../external/jtkelm2/scripts/wildcards.py -Path ./scripts/wildcards.py
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

New-Item -Type SymbolicLink -Force -Target ../external/dynamic_prompting/dynamic_prompting.py -Path scripts/dynamic_prompting.py

New-Item -Type Junction -Target $PWD/external/boorucomplete/tags/ -Path ./tags -ErrorAction SilentlyContinue
New-Item -Type SymbolicLink -Force -Target ../external/boorucomplete/javascript/tagAutocomplete.js -Path ./javascript/tagAutocomplete.js
New-Item -Type SymbolicLink -Force -Target ../external/boorucomplete/scripts/tag_autocomplete_helper.py -Path ./scripts/tag_autocomplete_helper.py

# Incompatible with `a1111-sd-webui-tagcomplete`
# Any files accessed by Gradio need to exist under the root of the application
#New-Item -Type Junction -Target "$((Get-Location).Path)\..\..\external\stable-diffusion\wildcards\" -Path "./scripts/wildcards" -ErrorAction SilentlyContinue

# Instead of creating a symlink to files that exist outside of the repository,
# copy external wildcards into a directory under the application root 
Copy-Item -Recurse -Force "$((Get-Location).Path)\..\..\external\stable-diffusion\wildcards" -Path "./scripts/wildcards" -ErrorAction SilentlyContinue

# Recurse through files in the wildcards directory and set them to read only
# This will help ensure we don't make updates to the wildcards in the application root
# and later overwrite with changes via this script
Get-ChildItem -File ./scripts/wildcards -Recurse |
    Set-ItemProperty -Name IsReadOnly -Value $true
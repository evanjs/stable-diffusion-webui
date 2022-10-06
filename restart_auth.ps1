$task = "Stable Diffusion WebUI (Automatic)"

Stop-ScheduledTask $task
gsudo Start-ScheduledTask $task
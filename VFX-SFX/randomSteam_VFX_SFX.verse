using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }

vfx_loop_controller := class(creative_device):

    @editable
    VFX : vfx_spawner_device = vfx_spawner_device{}

    @editable
    AudioPlayer : audio_player_device = audio_player_device{}

    OnBegin<override>()<suspends>:void =
        # Start the loop in a separate task
        spawn{VFXLoop()}

    VFXLoop()<suspends>:void =
        loop:
            # disables the VFX right away
            VFX.Disable()
            # Stop any playing audio
            AudioPlayer.Stop()

            # Wait a random 10-20 seconds
            RandomDelay := GetRandomFloat(10.0, 20.0)
            Sleep(RandomDelay)

            # Enable the VFX
            VFX.Enable()
            # Start the audio
            AudioPlayer.Play()

            # Wait 7 seconds
            Sleep(5.0)

            # Disable the VFX again
            VFX.Disable()
            # Stop the audio
            AudioPlayer.Stop()

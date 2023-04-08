## What is this?

aap-juce-plugin-host is a port of JUCE AudioPluginHost (`JUCE/extras/AudioPluginHost`) to [aap-juce](https://github.com/atsushieno/aap-juce).

It used to be a normative use case for of `aap_audio_plugin_client` module (plugin hosting part), which is now taken by aap-juce-simple-host repo. This JUCE app port still works, but it is not giving best aap-juce experience (e.g. you cannot connect nodes by touches, without mouse).

It should be noted that AudioPluginHost is not very optimal for AAP (very minimalistic changes to the original sources were made). The audio settings are not optimal for AAP and the audio output sounds crippled. JUCE plugins are, on the other hand, in general fine and they give good audio outputs through their AAP `MidiDeviceService`, for example.

## Building

This application is (still) based on Projucer. (There is an incomplete CMake based port in another branch and it may become a thing at some stage, but since it involves JUCE changes that we would be hesitant to add more.)

The normative build command is `make`. It will copy AudioPluginHost sources from `external/JUCE`. And this submodule is used for `Projucer` (to generate Android build files for further tweaks by aap-juce build scripts) and standard JUCE modules, just like other aap-juce apps do (but without copying).

For further build dependencies, the GitHub Actions build setup in `.github/workflows/actions.yml` would give you more details. Namely It runs Projucer so any dependencies for Projucer must be prepared.

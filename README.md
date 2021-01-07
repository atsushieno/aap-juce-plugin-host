This is a refresh structuring of AAP-JUCE sample builder, specific to AudioPluginHost.

`aap-juce` subdirectory right now contains files directly, but it will be the actual `aap-juce` repository contents once everything involved is sorted out. Until then, this repository is an ongoing hack.

This repository contains JUCE as a dependency for simpler reason: AudioPluginHost is the application within itself. Other JUCE app ports would have different structure, or even aap-juce may submodule JUCE by itself (then this repo will change as well).

Currently it builds, but the resulting host app fails to instantiate any plugin. Needs investigation.
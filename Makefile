
MINIMIZE_INTERMEDIATES=0
NDK_VERSION=21.2.6472646
JUCE_DIR=$(shell pwd)/external/JUCE
PROJUCER_BIN_LINUX=$(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/Projucer
PROJUCER_BIN_DARWIN=$(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/Debug/Projucer.app/Contents/MacOS/Projucer
GRADLE_TASK=build

ifeq ($(shell uname), Linux)
	PROJUCER_BIN=$(PROJUCER_BIN_LINUX)
else
ifeq ($(shell uname), Darwin)
	PROJUCER_BIN=$(PROJUCER_BIN_DARWIN)
else
	PROJUCER_BIN=___error___
endif
endif


.PHONY:
all: build

.PHONY:
build: prepare build-aap build-samples

.PHONY:
prepare: build-projucer

.PHONY:
build-projucer: $(PROJUCER_BIN)
	@echo "Projucer target: $(PROJUCER_BIN)"

$(PROJUCER_BIN_LINUX):
	make -C $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/intermediate/ ; \
	fi

$(PROJUCER_BIN_DARWIN):
	xcodebuild -project $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/Projucer.xcodeproj
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/intermediate/ ; \
	fi

.PHONY:
build-aap:
	cd external/android-audio-plugin-framework && make MINIMIZE_INTERMEDIATES=$(MINIMIZE_INTERMEDIATES)

.PHONY:
build-samples: build-audiopluginhost

.PHONY:
dist:
	mkdir -p release-builds
	mv  apps/AudioPluginHost/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk  release-builds/AudioPluginHost-release.apk

.PHONY:
build-audiopluginhost: create-patched-pluginhost do-build-audiopluginhost
.PHONY:
do-build-audiopluginhost:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) APPNAME=AudioPluginHost PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) SKIP_METADATA_GENERATOR=1 GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/AudioPluginHost/AudioPluginHost.jucer

.PHONY:
create-patched-pluginhost: apps/AudioPluginHost/.stamp 

apps/AudioPluginHost/.stamp: \
		external/JUCE/extras/AudioPluginHost/** \
		apps/juceaaphost.patch \
		apps/override.AudioPluginHost.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  AudioPluginHost  external/JUCE/extras/AudioPluginHost \
		apps/AudioPluginHost  ../juceaaphost.patch  3  apps/override.AudioPluginHost.jucer


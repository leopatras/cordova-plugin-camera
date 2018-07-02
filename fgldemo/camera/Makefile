# Property of Four Js*
# (c) Copyright Four Js 2017, 2017. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
# 
# Four Js and its suppliers do not warrant or guarantee that these
# samples are accurate and suitable for your purposes. Their inclusion is
# purely for information purposes only.

#calling make without parameters simply creates an GMI executable for the simulator
#use "make gmi.install" to install on the simulator or device depending on the TARGET

BUNDLE_IDENTIFIER   = com.4js.camerademo
BUNDLE_IDENTIFIER_GMA = com.fourjs.camerademo
APPNAME             = CDVCamera
DEVICE              = simulator
MODE                = debug
IDENTITY='(59W7RY75ZU)'
PROVISIONING_PROFILE=/Users/leo/Library/MobileDevice/Provisioning\ Profiles/4js_wildcard
VERBOSE=yes

PLUGIN=../..
ABSPATH=$(abspath .)
DEMODIR=$(shell  dirname $(ABSPATH))
PLUGINDIR=$(shell dirname $(DEMODIR))
GMAPLUGIN=$(notdir $(PLUGINDIR))
# in case you build the demo when having the plugin checked out of github 
# then we use the native code from this repository

MODULES  = $(patsubst %.4gl, %.42m, $(wildcard *.4gl))
FORMS    = $(patsubst %.per, %.42f, $(wildcard *.per))

%.42m: %.4gl
	FGLLDPATH=$(FGLLDPATH) fglcomp -M $*

%.42f: %.per
	fglform -M $*

all:: $(MODULES) $(FORMS)


run: main.42m
	FGLLDPATH=$(FGLLDPATH) fglrun main

define gmibuild
	gmibuildtool --install=$(1) --verbose=$(VERBOSE) --app-name=$(APPNAME) --bundle-id=$(BUNDLE_IDENTIFIER) --provisioning=$(PROVISIONING_PROFILE) --certificate=$(IDENTITY) --device=$(DEVICE) --mode=$(MODE) $(EXTENSION_LIBS) --build-cordova=$(PLUGIN)
endef

gmi.build: all 
	$(call gmibuild,no)

gmi.install: all 
	$(call gmibuild,yes)

openxcode:
	@rm -f gmi.env
ifdef GMIDIR
	echo "export GMIDIR=$(GMIDIR)" > gmi.env
endif
ifdef FGLDIR
	echo "export FGLDIR=$(FGLDIR)" >> gmi.env
else
	$(error FGLDIR must be set)
endif
	open camera.xcodeproj

gma.build: all 
#build the native plugin out of this repository  and install it in GMA
	cd ../../.. && gmabuildtool scaffold --install-plugins $(GMAPLUGIN) && cd -
	gmabuildtool build --build-quietly --build-cordova $(GMAPLUGIN) --build-app-package-name $(BUNDLE_IDENTIFIER_GMA) 

gma.installsim: gma.build
	$$ANDROID_SDK_ROOT/platform-tools/adb install -r ./gma/project/app/build/app/outputs/apk/app-unsigned.apk

clean::
	rm -f *.sch *.dbs *.42*
	rm -rf build bin distbin
	rm -f cordovamap.txt gmi/*.a gmi/link_flags.sh *.4pwvs *.4pwdb

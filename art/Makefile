
TARGET := ../game/assets/

.PHONY = all

ifeq ($(OS),Windows_NT)
	ASEPRITE := C:/Program Files (x86)/Steam/steamapps/common/Aseprite/Aseprite.exe
else
	# this is only for my compiled version of aseprite on Mac OSX
	ASEPRITE := /Users/rluis/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/MacOS/aseprite
endif



# TODO: add spikes, swinging lights
all: \
	$(TARGET)tileset.png \
	$(TARGET)player.png \
	$(TARGET)background_forest_sky.png




$(TARGET)tileset.png: tileset.aseprite
	"$(ASEPRITE)" -b tileset.aseprite --ignore-layer "Background" -save-as $(TARGET)tileset.png

$(TARGET)player.png: player.aseprite
	"$(ASEPRITE)" -b player.aseprite -sheet $(TARGET)player.png --sheet-width 256


$(TARGET)background_forest_sky.png : background_forest.aseprite
	"$(ASEPRITE)" -b background_forest.aseprite -save-as $(TARGET)background_forest_{layer}.png

















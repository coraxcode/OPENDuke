# Makefile for OPENDuke by Annihilat0r – GCC 9.5.0 (MinGW-w64 i686, 32-bit)
# Target environment:
#   - Windows 11
#   - MinGW-w64 i686-msvcrt-posix-dwarf, gcc/g++ 9.5.0
#
# Assumed layout:
#   .\
#     duke3d_w32.sln
#     Engine\
#       Engine.vcproj
#       src\...
#     Game\
#       Game.vcproj
#       Game.rc (not used here)
#       src\...
#     lib\
#       dxguid\dxguid.lib
#       sdl\SDL.lib, SDL.dll, SDLmain.lib, include\...
#       sdl_mixer\SDL_mixer.lib, SDL_mixer.dll, include\...

SHELL := cmd.exe

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------

CC    := gcc
CXX   := g++
AR    := ar
RM    := del /Q /F
RMDIR := rmdir /S /Q

# ---------------------------------------------------------------------------
# Main directories
# ---------------------------------------------------------------------------

ROOT_DIR       := .
ENGINE_DIR     := $(ROOT_DIR)/Engine
GAME_DIR       := $(ROOT_DIR)/Game
LIB_DIR        := $(ROOT_DIR)/lib

ENGINE_SRC_DIR := $(ENGINE_DIR)/src
GAME_SRC_DIR   := $(GAME_DIR)/src

BUILD_DIR      := $(ROOT_DIR)/build
OBJDIR_ENGINE  := $(BUILD_DIR)/engine
OBJDIR_GAME    := $(BUILD_DIR)/game
BINDIR         := $(ROOT_DIR)/bin

# Object subdirectories
OBJDIR_ENGINE_ENET    := $(OBJDIR_ENGINE)/enet
OBJDIR_GAME_AUDIOLIB  := $(OBJDIR_GAME)/audiolib
OBJDIR_GAME_MIDI      := $(OBJDIR_GAME)/midi

# ---------------------------------------------------------------------------
# SDL / SDL_mixer – includes and libs local to the project
# ---------------------------------------------------------------------------

SDL_INC_DIR        ?= $(LIB_DIR)/sdl/include
SDL_MIXER_INC_DIR  ?= $(LIB_DIR)/sdl_mixer/include

SDL_LIB_DIR        ?= $(LIB_DIR)/sdl
SDL_MIXER_LIB_DIR  ?= $(LIB_DIR)/sdl_mixer
DXGUID_LIB_DIR     ?= $(LIB_DIR)/dxguid

SDL_CFLAGS        :=
SDL_MIXER_CFLAGS  :=
ifeq ($(strip $(SDL_INC_DIR)),)
else
  SDL_CFLAGS += -I$(SDL_INC_DIR)
endif
ifeq ($(strip $(SDL_MIXER_INC_DIR)),)
else
  SDL_MIXER_CFLAGS += -I$(SDL_MIXER_INC_DIR)
endif

# ---------------------------------------------------------------------------
# Global flags – translated from VCCLCompilerTool (Release|Win32)
# ---------------------------------------------------------------------------

CFLAGS   := -O2 -pipe -fomit-frame-pointer -funsigned-char -fno-stack-protector \
            -Wall -Wextra -MMD -MP
CXXFLAGS := $(CFLAGS) -std=gnu++03

LDFLAGS := -mconsole

# Libraries (VCLinkerTool.Release|Win32 -> GCC/MinGW):
#   dxguid.lib, sdl.lib, sdl_mixer.lib + system libs.
LDLIBS := \
  "$(DXGUID_LIB_DIR)/dxguid.lib" \
  "$(SDL_LIB_DIR)/SDL.lib" \
  "$(SDL_MIXER_LIB_DIR)/SDL_mixer.lib" \
  -lwinmm \
  -lws2_32

# ---------------------------------------------------------------------------
# Preprocessor definitions (PreprocessorDefinitions)
# ---------------------------------------------------------------------------

# Engine.vcproj | Release|Win32
CPPFLAGS_ENGINE := \
  -DnDBGRECORD \
  -DnDEBUG \
  -DPLATFORM_WIN32 \
  -DUDP_NETWORKING \
  -DWIN32 \
  -D_LIB \
  -D_CRT_SECURE_NO_DEPRECATE \
  -D_CRT_NONSTDC_NO_DEPRECATE

# Game.vcproj | Release|Win32
CPPFLAGS_GAME := \
  -DnDBGRECORD \
  -DCHECK_XDUKE_REV \
  -DnDEBUG \
  -DWIN32 \
  -D_CONSOLE \
  -DPLATFORM_WIN32 \
  -D_CRT_SECURE_NO_DEPRECATE \
  -D_CRT_NONSTDC_NO_DEPRECATE

# ---------------------------------------------------------------------------
# Includes (translated from AdditionalIncludeDirectories)
# ---------------------------------------------------------------------------

ENGINE_INCLUDES := \
  -I$(ENGINE_SRC_DIR) \
  -I$(ENGINE_SRC_DIR)/enet/include \
  $(SDL_CFLAGS)

GAME_INCLUDES := \
  -I$(GAME_SRC_DIR) \
  -I$(ENGINE_SRC_DIR) \
  $(SDL_CFLAGS) \
  $(SDL_MIXER_CFLAGS)

# ---------------------------------------------------------------------------
# Main target
# (VCLinkerTool->OutputFile = $(OutDir)/$(SolutionName).exe -> duke3d_w32.exe)
# ---------------------------------------------------------------------------

TARGET := duke3d_w32.exe
EXE    := $(BINDIR)/$(TARGET)

# ---------------------------------------------------------------------------
# Engine sources (Engine.vcproj | Release|Win32)
# ---------------------------------------------------------------------------

ENGINE_C_SRCS := \
  $(ENGINE_SRC_DIR)/a.c \
  $(ENGINE_SRC_DIR)/cache1d.c \
  $(ENGINE_SRC_DIR)/Engine.c \
  $(ENGINE_SRC_DIR)/mmulti.c \
  $(ENGINE_SRC_DIR)/pragmas.c \
  $(ENGINE_SRC_DIR)/sdl_driver.c \
  $(ENGINE_SRC_DIR)/enet/host.c \
  $(ENGINE_SRC_DIR)/enet/list.c \
  $(ENGINE_SRC_DIR)/enet/memory.c \
  $(ENGINE_SRC_DIR)/enet/packet.c \
  $(ENGINE_SRC_DIR)/enet/peer.c \
  $(ENGINE_SRC_DIR)/enet/protocol.c \
  $(ENGINE_SRC_DIR)/enet/unix.c \
  $(ENGINE_SRC_DIR)/enet/win32.c

ENGINE_CPP_SRCS := \
  $(ENGINE_SRC_DIR)/mmulti_stable.cpp

ENGINE_OBJS := \
  $(ENGINE_C_SRCS:$(ENGINE_SRC_DIR)/%.c=$(OBJDIR_ENGINE)/%.o) \
  $(ENGINE_CPP_SRCS:$(ENGINE_SRC_DIR)/%.cpp=$(OBJDIR_ENGINE)/%.o)

ENGINE_DEPS := $(ENGINE_OBJS:.o=.d)
ENGINE_LIB  := $(BUILD_DIR)/libengine.a

# ---------------------------------------------------------------------------
# Game sources (Game.vcproj | Release|Win32)
# ---------------------------------------------------------------------------

GAME_C_SRCS := \
  $(GAME_SRC_DIR)/actors.c \
  $(GAME_SRC_DIR)/animlib.c \
  $(GAME_SRC_DIR)/config.c \
  $(GAME_SRC_DIR)/control.c \
  $(GAME_SRC_DIR)/game.c \
  $(GAME_SRC_DIR)/gamedef.c \
  $(GAME_SRC_DIR)/global.c \
  $(GAME_SRC_DIR)/keyboard.c \
  $(GAME_SRC_DIR)/menues.c \
  $(GAME_SRC_DIR)/player.c \
  $(GAME_SRC_DIR)/premap.c \
  $(GAME_SRC_DIR)/rts.c \
  $(GAME_SRC_DIR)/scriplib.c \
  $(GAME_SRC_DIR)/sector.c \
  $(GAME_SRC_DIR)/sounds.c \
  $(GAME_SRC_DIR)/audiolib/dsl.c \
  $(GAME_SRC_DIR)/audiolib/fx_man.c \
  $(GAME_SRC_DIR)/audiolib/ll_man.c \
  $(GAME_SRC_DIR)/audiolib/multivoc.c \
  $(GAME_SRC_DIR)/audiolib/mv_mix.c \
  $(GAME_SRC_DIR)/audiolib/mvreverb.c \
  $(GAME_SRC_DIR)/audiolib/nodpmi.c \
  $(GAME_SRC_DIR)/audiolib/pitch.c \
  $(GAME_SRC_DIR)/audiolib/user.c \
  $(GAME_SRC_DIR)/console.c \
  $(GAME_SRC_DIR)/cvar_defs.c \
  $(GAME_SRC_DIR)/cvars.c 

GAME_CPP_SRCS := \
  $(GAME_SRC_DIR)/midi/win_midiout.cpp \
  $(GAME_SRC_DIR)/midi/xmidi.cpp

GAME_OBJS := \
  $(GAME_C_SRCS:$(GAME_SRC_DIR)/%.c=$(OBJDIR_GAME)/%.o) \
  $(GAME_CPP_SRCS:$(GAME_SRC_DIR)/%.cpp=$(OBJDIR_GAME)/%.o)

GAME_DEPS := $(GAME_OBJS:.o=.d)

# ---------------------------------------------------------------------------
# Directories to be created
# ---------------------------------------------------------------------------

DIRS := \
  $(BUILD_DIR) \
  $(OBJDIR_ENGINE) \
  $(OBJDIR_ENGINE_ENET) \
  $(OBJDIR_GAME) \
  $(OBJDIR_GAME_AUDIOLIB) \
  $(OBJDIR_GAME_MIDI) \
  $(BINDIR)

# ---------------------------------------------------------------------------
# Top-level rules
# ---------------------------------------------------------------------------

.PHONY: all clean engine game dirs

all: $(EXE)

engine: $(ENGINE_LIB)
game: $(EXE)

dirs: $(DIRS)

$(DIRS):
	if not exist "$@" mkdir "$@"

# ---------------------------------------------------------------------------
# Final link
# ---------------------------------------------------------------------------

$(EXE): $(ENGINE_LIB) $(GAME_OBJS) | $(BINDIR)
	$(CXX) $(LDFLAGS) -o "$@" $(GAME_OBJS) $(ENGINE_LIB) $(LDLIBS)

# ---------------------------------------------------------------------------
# Engine static library
# ---------------------------------------------------------------------------

$(ENGINE_LIB): $(ENGINE_OBJS) | $(BUILD_DIR)
	$(AR) rcs $@ $^

# ---------------------------------------------------------------------------
# Compilation rules – Engine
# ---------------------------------------------------------------------------

$(OBJDIR_ENGINE)/%.o: $(ENGINE_SRC_DIR)/%.c | dirs
	$(CC) $(CFLAGS) $(CPPFLAGS_ENGINE) $(ENGINE_INCLUDES) -c $< -o $@

$(OBJDIR_ENGINE)/%.o: $(ENGINE_SRC_DIR)/%.cpp | dirs
	$(CXX) $(CXXFLAGS) $(CPPFLAGS_ENGINE) $(ENGINE_INCLUDES) -c $< -o $@

# ---------------------------------------------------------------------------
# Compilation rules – Game
# ---------------------------------------------------------------------------

$(OBJDIR_GAME)/%.o: $(GAME_SRC_DIR)/%.c | dirs
	$(CC) $(CFLAGS) $(CPPFLAGS_GAME) $(GAME_INCLUDES) -c $< -o $@

$(OBJDIR_GAME)/%.o: $(GAME_SRC_DIR)/%.cpp | dirs
	$(CXX) $(CXXFLAGS) $(CPPFLAGS_GAME) $(GAME_INCLUDES) -c $< -o $@

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------

clean:
	-$(RM) $(ENGINE_OBJS) $(GAME_OBJS) $(ENGINE_DEPS) $(GAME_DEPS) 2>nul
	-$(RM) $(EXE) 2>nul
	-$(RMDIR) "$(BUILD_DIR)" 2>nul
	-$(RMDIR) "$(BINDIR)" 2>nul

# ---------------------------------------------------------------------------
# Automatic dependencies
# ---------------------------------------------------------------------------

-include $(ENGINE_DEPS) $(GAME_DEPS)

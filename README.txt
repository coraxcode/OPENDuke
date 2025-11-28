OPENDuke by Annihilat0r (CoraxCODE)

Install GCC 9.5.0 32-bit from the link: https://winlibs.com/

Configure the GCC environment variable PATH. Set it to C:\mingw32\bin Open the Run dialog (Win+R), type sysdm.cpl, go to Advanced \ Environment Variables. This is the step-by-step process to configure the environment variable on Windows 11.

In Environment Variables, click on Path under System Variables \ New. In both the Variable name and Variable value fields, enter C:\mingw32\bin, then click OK and OK again to exit.

Open the Run dialog (Win+R), type cmd, navigate to the OPENDuke directory where the Makefile is located, and compile with the command mingw32-make.

After compiling, a bin directory will be generated with the executable duke3d_w32.exe. Add the SDL.dll from the lib\sdl directory and the SDL_mixer.dll from the lib\sdl_mixer directory to the bin directory where the executable is located, along with the duke3d.grp file you have.

About the generated executable:
If you want to distribute the GCC-compiled executable duke3d_w32.exe, add the following GCC DLLs to the executable's bin directory:

libgcc_s_dw2-1.dll
libwinpthread-1.dll
libstdc++-6.dll

This will allow the executable to run on any machine that does not have GCC installed.

NOTE: The default Makefile compiles with SDL1. The Makefile-SDL2 is not compiling correctly yet because it is necessary to make changes to the code!

NOTE 2: You can always clean and recompile by using the mingw32-make clean command.

NOTE 3: On Windows, you can search for lines of code using the command findstr /S /N /C:"command-line" *.c *.cpp *.h.

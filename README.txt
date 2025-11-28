OPENDuke by Annihilat0r (CoraxCODE)

Install GCC 9.5.0 32-bit from the link: https://winlibs.com/

Configure the GCC environment variable PATH. Set it to C:\mingw32\bin Open the Run dialog (Win+R), type sysdm.cpl, go to Advanced \ Environment Variables. This is the step-by-step process to configure the environment variable on Windows 11.

In Environment Variables, click on Path under System Variables \ New. In both the Variable name and Variable value fields, enter C:\mingw32\bin, then click OK and OK again to exit.

Open the Run dialog (Win+R), type cmd, navigate to the OPENDuke directory where the Makefile is located, and compile with the command mingw32-make.

NOTE: You can always clean and recompile by using the mingw32-make clean command.
NOTE 2: On Windows, you can search for lines of code using the command findstr /S /N /C:"command-line" *.c *.cpp *.h.

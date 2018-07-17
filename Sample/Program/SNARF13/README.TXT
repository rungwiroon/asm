README.TXT     1-Sep-2006

Snarf takes snapshots of almost any DOS text or graphic screen. It's
particularly useful under Windows XP because this version of Windows
does not capture a DOS graphic screen using the Print Screen key.

When run, Snarf is installed into memory as a Terminate-and-Stay-
Resident (TSR) program. Pressing Alt+S captures whatever is on the
screen. A beep indicates that the image is being saved to disk. A second
beep indicates that the capture is complete. The image is saved in the
current directory (or folder) in a file called SNARF000.BMP. Additional
snapshots are saved in SNARF001.BMP, SNARF002.BMP ... SNARF999.BMP. Note
that both text and graphics are saved in a graphic file format. Most
images are saved in a second or two, but some graphic formats can take up
to 30 seconds to save.

Snarf works for all text and graphic modes: CGA, EGA, VGA, and VESA (up
through 11B).

Three beeps indicates an error, such as an unsupported display mode. An
error message also appears (see below).

An 80386 CPU (or better) is required. (Pentiums and Athlons are way more
than sufficient.)

Because Alt+S might be needed by the program you are taking a snapshot
of, other hot keys can be specified. When Snarf is first run, if a number
is entered on the command line, it will change the scan code that is used
for the hot key. For example, to change the hot key to Alt+C type: "snarf
46". (Note that the value is in decimal, not hex.) After Snarf has been
installed, the hot key cannot be changed by attempting to reinstall
Snarf. A list of scan codes is provided in SCANCODE.TXT.


KNOWN PROBLEMS

Under Windows XP, Snarf prevents the use of long file names. This is a
problem with any TSR running under the Windows NT family. The problem is
related to the fact that 32-bit CMD is switched to 16-bit Command without
any indication.

A related problem is that DOSKEY quits working after Snarf (or any TSR)
is installed. (For example, the up-arrow key no longer selects previous
commands.) Reinstalling DOSKEY does not solve the problem, but installing
a similar program, called CED, does solve it.

Some game programs take complete control over the keyboard, which
prevents Snarf from receiving a keystroke. Thus these images cannot be
captured. (I might be persuaded to add a timer, or some other kludge, to
get around this problem.)

VESA version 2.0 allowed manufacturers to define their own modes above
11B. These are currently not supported.


ERROR MESSAGES

If Snarf detects an error, it blanks the screen and displays a message
with a pair of error codes. (Even though your original screen image is
gone, your original program is still running. If possible, type a command
to refresh the screen. If you were at a DOS prompt, a new prompt will
appear if you press the Enter key.)

Error: 1 mmm indicates an unsupported display mode. The mode is the
second number (mmm). Snarf supports 44 display modes.

Error: 2 indicates an attempt to save more than 999 image files in the
current directory.

Error: 3 xxx indicates that the output file could not be written to disk.
The second code (xxx) is the DOS error code, which provides details.
Common DOS error codes are 3: diskette not inserted into the drive; and
5: write-protected diskette. Another possible error is that the root
directory is full.

Error: 4 indicates insufficient disk space to save the image file.


USE AT YOUR OWN RISK

Snarf has been verified on many different kinds of computers running DOS
5.0, Windows 3.1, Windows 98, and Windows XP; however it is a complex
program that may not work on all PCs for all programs. If you discover a
problem, I'd appreciate hearing about it.

Obligatory legal statement:

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License version 2 as published
by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program (in the file LICENSE.TXT); if not, write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


Thanks,
Loren

loren_blaney@idcomm.com

This is a minor mode for hiding passwords.  It's useful if you
manage your passwords in text files (perhaps automatically
encrypted and decrypted by EasyPG) and want to prevent shoulder
surfing.

When enabled, any passwords will appear as ******, but you'll still
be able to copy the password to the clipboard.

By default, passwords are marked by delimiting them with braces ([]).
For example:

root: [supersecret]

will display as

root: [******]

You can customize hidepw-pattern to match against arbitrary regular
expressions.  Just make sure to include one capturing group (\(\))
since the group marks the actual password.  You can also customize
the mask (******) that obscures the password.

You can enable hidepw-mode automatically on .gpg files with:

(add-to-list 'auto-mode-alist '("\\.gpg\\'" . hidepw-mode))

Using with pass (https://www.passwordstore.org/):

pass requires that the first line of the file is a password.  To hide
the first line, customize the hidepw-hide-first-line variable.

Differences from password-mode (https://github.com/juergenhoetzel/password-mode/):

|                   | password-mode   | hidepw                    |
|-------------------+-----------------+---------------------------|
| hiding via        | overlay         | font-lock                 |
| password input    | password prompt | normal input              |
| match via         | prefix regexp   | regexp with capture group |
| multiple patterns | yes             | yes                       |
| supports pass     | no*             | yes                       |

While the password prompt is a nice feature of password-mode, I found
it to be difficult to use and that it could get into inconsistent states.
If you'd like to input passwords without them ever being visible, input the
delimiters ([]) first and then input the password between them.

* It might be possible to use pass with password-mode with the right
regexp.

Notes:

You won't be able to move the cursor within the password (it will
behave like a single character), but deleting the delimiter from
either side will reveal the password and make it editable.  Just add
the delimiter back to hide it again.

This mode turns on font-lock-mode (and won't turn it off when you
turn off this mode).

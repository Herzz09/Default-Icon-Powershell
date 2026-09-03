# Default-Icon-Powershell

**Dev:** Herzz09  
**Date:** 09/02/2026  
**Name:** Default_Icon_PowerShell.ps1

A PowerShell script that registers `.ps1` files in the Windows Explorer **"New"** context menu (`ShellNew`), allowing you to create new PowerShell scripts directly from **Right-click > New > Script do Windows PowerShell**, just like you would with a `.txt` or `.docx` file.

## What it does

When executed, `Default_Icon_PowerShell.ps1`:

1. Self-elevates to Administrator (required to write to `C:\Windows\ShellNew`).
2. Creates the `C:\Windows\ShellNew` folder if it doesn't already exist.
3. Generates a `.reg` file that registers the `.ps1` extension in `ShellNew`.
4. Creates a `template.ps1` file — the base content used every time you create a new `.ps1` file from the Explorer menu.
5. Moves `new_powershell.reg` and `template.ps1` into `C:\Windows\ShellNew`.

After the script finishes, both `new_powershell.reg` and `template.ps1` will exist inside `C:\Windows\ShellNew`, and the **"New PowerShell Script"** option will be available in the Explorer's right-click menu.

## Customizing your template

You can personalize `template.ps1` (located at `C:\Windows\ShellNew\template.ps1`) with your favorite commands, snippets, or boilerplate code. From that point on, every new `.ps1` file you create through the Explorer's "New" menu will automatically come pre-filled with that content.

## Requirements

- Windows 10/11
- PowerShell 5.1+
- Administrator privileges (the script handles self-elevation automatically)

## Usage

```powershell
.\Default_Icon_Powershell.ps1
```

Right-click on your Desktop or inside any folder in File Explorer, select **New**, and **"Script do Windows PowerShell"** will now appear in the list — right next to Word, Excel, and other registered file types.

## Notes

- The script only touches the `.ps1` file association within `ShellNew`; it does not modify the default program used to *open* `.ps1` files.
- Running the script again is safe — it will simply overwrite the existing registry entry and template.

## License

MIT

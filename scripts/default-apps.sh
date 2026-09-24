#!/usr/bin/env bash
set -euo pipefail

# Make VS Code (default) or Cursor the default app for text and code files
# that would otherwise open in TextEdit, Xcode, etc. Uses UTIs with the "editor" role because duti's
# extension form and "all" role silently fail for types the editor doesn't declare.
UTIS=(
  public.plain-text
  net.daringfireball.markdown
  public.json
  public.yaml
  public.xml
  public.shell-script
  public.zsh-script
  public.python-script
  public.source-code
  public.swift-source
  public.c-source
  public.c-header
  public.c-plus-plus-source
  public.objective-c-source
  com.netscape.javascript-source
  public.toml
  com.microsoft.ini
  public.css
)

echo "==> Which editor should open text and code files?"
echo "    1) VS Code (default)"
echo "    2) Cursor"
read -rp "    Choice [1]: " choice

case "${choice:-1}" in
  1) app="Visual Studio Code"; bundle_id="com.microsoft.VSCode" ;;
  2) app="Cursor"; bundle_id="com.todesktop.230313mzl4w4u92" ;;
  *) echo "ERROR: invalid choice '$choice'" >&2; exit 1 ;;
esac

echo "==> Setting $app as the default editor..."
for uti in "${UTIS[@]}"; do
  [[ "$(duti -d "$uti" 2>/dev/null)" == "$bundle_id" ]] && continue
  duti -s "$bundle_id" "$uti" editor
done
echo "  Done. Check a type with: duti -x md"

#!/bin/bash

INCOMING="${1:-in.tsv}"
OUTGOING="${2:-out.htmlfrag}"

read -r -d '' TOPTABLEPART << 'EOF'
  <div id="tableOuter">
    <div id="tableInner">
      <table style="white-space:revert;">
        <caption>
          <div style="text-align:center; font-size: xx-large; padding-bottom: 1em;">links
        </caption>
        <thead style="z-index:initial;">
          <tr class="font-weight:bold;">
            <td style="width:50%;">
              <strong>STORY</strong>
            </td>
            <td>
              <strong>BUT WHY?</strong>
            </td>
          </tr>
        </thead>
        <tbody>
EOF

read -r -d '' BOTTOMTABLEPART << 'EOF'
        </tbody>
        <tfoot>
          <tr>
            <td>
              <a href=""></a>
            </td>
            <td>
              <p></p>
            </td>
          </tr>
          <tr>
            <td colspan="2" style="text-align: center;">---</td>
          </tr>
        </tfoot>

      </table>
    </div>
  </div>
EOF

echo 
echo "convert google spreadsheet with articles to a table to put on blog"

echo "$TOPTABLEPART" > "$OUTGOING"

tail -n +4 "$INCOMING"  | (awk '{ print "          <tr>\n            <td>\n              <a href=''\""$3"\"''>\n                "$2"\n              </a>\n            </td>\n            <td>\n              "$1"\n            </td>\n          </tr>" }' FS='\t') >> "$OUTGOING"

echo "$BOTTOMTABLEPART" >> "$OUTGOING"



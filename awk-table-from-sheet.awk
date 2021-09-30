#!/bin/awk -f
BEGIN {FS="\t";RS="\r\n";
  }
  
  {print "          <tr>\n            <td>\n              <a href=\""$3"\">\n                "$2"\n              </a>";
  if ($4==""){
    print "            </td>\n            <td>\n              "$1"\n            </td>\n          </tr>";
  }
  else{printf "              <br/><hr/>\n              ";
  printf "<a href=\"";
  printf $5;
  print "\">\n                "$4"\n              </a><br/>";
  #else{print "              <hr/>\n              <a href=\""$5"\">\n                "$4"\n              </a>";
    print "            </td>\n          <td>\n          "$1"</td>\n          </tr>";
  }

  }
  #if ($4=="")
  #  {
  #    print "            </td>\n            <td>\n              "$1"\n            </td>\n          </tr>";
  #  }
  #else
  #  {
  #    print "<br/>\n<hr/>\n            <a href=''\""$5"\"''>\n                "$4"\n            </a>\n                    </td>\n            <td>\n              "$1"\n            </td>\n          </tr>";
  #  }
#}
END {}

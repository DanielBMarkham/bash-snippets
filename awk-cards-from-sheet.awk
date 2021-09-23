#!/bin/awk -f
BEGIN {FS="\t";
  }
  
  {print "           <div class=card-column> <div class=card>\n            <div class=card>\n              <a href=\""$3"\">\n                "$2"\n              </a>";
  if ($4==""){
    print "            </div>\n            \n           </div> </div>";
  }
  else{printf "              <br/>\n              ";
  printf "<a href=\"";
  printf $5;
  print "\">\n                "$4"\n              </a><br/>";
  #else{print "              <hr/>\n              <a href=\""$5"\">\n                "$4"\n              </a>";
    print "            </div>\n          \n           </div> </div>";
  }

  }

END {}


# <a href=https://cdn.danielbmarkham.com/reference/original-articles/nerd-roundup/2021-09-10/Bad%20Astronomy%20_%20Wood%20may%20be%20a%20useful%20material%20for%20space%20missions%20(9_8_2021%208_48_42%20AM).html>
# <h4>
# Can you build a satellite made out of… wood?
# </h4>
# <p>
# Wooden satellites for the win! Never have to worry about them catching fire, right? Somehow I can picture some future YouTube DIY video where the guy makes his own Keyhole satellite
# </p>
# </a>


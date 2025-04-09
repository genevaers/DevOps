#!/bin/bash

echo "Arg0: $0";
echo "Arg1: $1"; # Job name
echo "Arg2: $2"; # Listings dataset (pds)

Job1="$1";
if [[ "$Job1" = "" ]]; then
  echo "No Jobname supplied";
  exit 1;
else
  echo "Jobname $Job1";
fi

Filel="$2";
if [[ "$Filel" = "" ]]; then
  echo "No listings file supplied";
  exit 1;
else
  echo "Listings file: $Filel";
fi

Fileo="isfin.txt"; # temporary ISFIN file

# echo "File1: $Filel";
File="'''$Filel($Job1)'''";

# echo "Listing written to: $File";
echo "Temporary ISFIN file: $Fileo";

echo "SET DISPLAY" > $Fileo;
echo "PREFIX $pref" >> $Fileo;
echo "OWNER" >> $Fileo;
echo "H ALL" >> $Fileo;
echo "++ALL" >> $Fileo;
echo "SORT END-DATE D END-TIME D" >> $Fileo;
echo "H ALL" >> $Fileo;
echo "++XDC" >> $Fileo;
echo "++<=$File>," >> $Fileo;
echo "<=' '>," >> $Fileo;
echo "<='OLD'>" >> $Fileo;
echo "++AFD END" >> $Fileo;

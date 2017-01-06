#!/bin/bash
# Hallo Welt -> HTML
# wr 30.12.99
# 13.05.01: Angepasst an Cygwin unter Windows
# 13.02.02: Index alphabetisch zu Zeilen zusammenfassen
# 06.10.04: Links eingefügt
# 30.06.05: Auch htm-Dateien und Bilder möglich
# 21.04.06: Neue Programme im Index fett anzeigen
# 05.07.07: Originales Hello-World-Programm am Anfang
# 10.04.08: Link auf 99-Beer-Sammlung
# 14.05.08: Ablage auf externem Server
# 20.05.08: Inhaltsverzeichnis-Frame erzeugen
# 10.08.08: "Back to index"-Link in Überschriftszeile
# 25.09.10: QR-Code eingefügt, E-Mail-Adresse gelöscht
# 17.08.14: Angepasst an OS X, Buttons für Google Plus/Twitter/Facebook/Reddit/LinkedIn/Xing
# 21.08.14: Monospaced-Font für <pre>, E-Mail-Adresse wieder eingefügt
# 16.09.14: Jetzt in eigener Domain
# 21.01.15: Eigener Twitter-Account
# 07.10.15: Datenschutzkonforme Social Media-Buttons mit Shariff
# 27.12.15: sources.txt mit Internet-Quellen eingefügt
# 27.12.15: Blau-/Sepia-Farbeschema (http://paletton.com/#uid=23G0u0kl6lP0O++b-xcuHb4T-00)
# 29.12.15: HTML-Validierung mit http://validator.w3.org
# 24.04.16: Vorläufiger Link auf Freewear-Homepage
# 06.05.16: Endgültiger Link auf Freewear-Homepage
# 08.05.16: Nur eine Datei, keine Frames mehr
# 12.08.16: Sharing-Buttons erzeugt mit http://sharingbuttons.io statt Shariff
# 20.08.16: Versionsverwaltung mit git eingeführt
# 06.01.17: Angepasst an Hosting auf GitHub

# Quellverzeichnis
DROPBOX=~/Dropbox
cd $DROPBOX/Privat/Wolfram/Homepage/helloworld/src || exit

# Ausgabeverzeichnis. Dabei handelt es sich um das Verzeichnis mit dem geklonten
# Github-Repository. Bespiel:
#
#	$ cd ~/Dropbox/Privat/Wolfram/Homepage/helloworld
#	$ rm -fr dst
#	$ git clone https://github.com/username/username.github.io dst
OUTDIR=$DROPBOX/Privat/Wolfram/Homepage/helloworld/dst

# Dateien
OUT=$OUTDIR/index.htm
TOC=/tmp/helloworld.toc.tmp
IDX=/tmp/helloworld.idx.tmp
NEW=/tmp/helloworld.new.tmp
rm -f $OUT $TOC $IDX $NEW

echo "Ausgabe nach $OUT" >&2

# Neue Dateien ermitteln
find files -mtime -30 -print >$NEW

# Index und Inhaltsverzeichnis erzeugen
echo >&2
echo "Erzeuge Index ..." >&2
PREV=""
for i in $(ls files/* | sort -f);do
  if [[ $i = *.htm ]];then
    ID=`basename $i .htm`
  else
    ID=`basename $i .txt`
  fi
  FIRST=$(echo "$ID" | cut -c1 | tr 'a-z' 'A-Z')
  if [ $FIRST -eq $FIRST ] 2>/dev/null;then
    FIRST="#"
  fi

  if [ "$FIRST" != "$PREV" ];then
    # Neuer Buchstabe beginnt
    echo -n "$FIRST " >&2
    echo "<br><span class=\"cap\">$FIRST </span>"
    echo "<br><span class=\"cap\">$FIRST</span><br>" >>$TOC

    PREV=$FIRST
  fi

  echo -n "<a href=\"#$ID\">"
  grep -q $i <$NEW
  ISNEW=$?
  ((ISNEW)) || echo -n "<b>"
  echo -n "$ID"
  ((ISNEW)) || echo -n "</b>"
  echo "</a>&nbsp;"

  # Eintrag im Inhalts-Frame
  (
    ((ISNEW)) || echo -n "<b>"
    echo -n "<a href=\"#$ID\">$ID</a><br>"
    ((ISNEW)) || echo -n "</b>"
	echo
  ) >>$TOC
done >>$IDX
echo >&2

# Ergebnis-HTML-Datei beginnen
[ -f $OUT ] && mv $OUT /tmp
cat >$OUT <<!
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="description" content="The largest collection of Hello World programs on the Internet.">
<meta name="author" content="Wolfram Rösler">
<meta name="date" content="`date +'%Y-%m-%dT%H:%M:%S%z'`">
<title>The Hello World Collection</title>
<link rel="canonical" href="http://helloworldcollection.de">
<link href="sharingbuttons.css" rel="stylesheet">
<style type="text/css">
  body { font-family: Verdana,sans-serif; text-align: justify; background-color: #FFFDF9; }
  pre {
    font-family: 'Lucida Console',Menlo,monospaced;
    font-size: small;
    overflow-x: scroll;
  }
  h1,h2 { color: #FFFDF9; background-color: #2E4973; padding: 2px; }
  a { color: #583904; }
  li { line-height: 1.5; }
  .cap {
    font-size: xx-large;
  }
  .sidebar {
    width: 20%;
    position: fixed;
    height: 100%;
    overflow: auto;
  }
  .main {
    margin-left: 20%;
    padding: 1px 16px;
  }
</style>
</head>
<body>
!

# Inhaltsverzeichnis ausgeben
cat >>$OUT <<!
<div class="sidebar">
  <h1>Contents</h1>
  <p>The latest additions are shown in <b>bold</b>.</p>
  <p style="font-size: small;">
!
cat $TOC >>$OUT
echo '</div>' >>$OUT

# Kopftext ausgeben
cat >>$OUT <<!
<div class="main">
<h1>The Hello World Collection</h1>
<p><img alt="Hello World!" src="hellopics/qrcode.png" style="float:right;margin-left: 5mm; margin-bottom: 5mm;">
"Hello World" is the first program one usually writes when
learning a new programming language. Having first been mentioned in Brian Kernighan's
<a href="https://www.bell-labs.com/usr/dmr/www/bintro.html">tutorial to the B programming language</a>,
it became widely known through Kernighan &amp; Ritchie's 1978 book that introduced
<a href="http://en.wikipedia.org/wiki/The_C_Programming_Language_(book)">&quot;The C Programming Language&quot;</a>,
where it read like this:</p>
<p style="font-family: 'Lucida Console',Menlo,monospaced; white-space: pre; margin-left: 4em;">main() {
    printf("hello, world\n");
}
</p>
<p>Since then, Hello World has been implemented in just about
every programming language on the planet. This collection includes
<b>`ls files | wc -l` Hello World programs</b> in as many more-or-less well known programming languages, plus
<b>`grep '<tr>' files/Human.htm | wc -l` <a href="#Human">human</a> languages</b>.</p>
<p>The programs in this collection are intended to be as minimal as
possible in the respective language. They are meant to demonstrate
how to output Hello World as simply as possible, not to show off
language features. For a collection of programs that tell more
about what programming in the languages actually is like, have a
look at the <a href="http://www.99-bottles-of-beer.net/">99 Bottles
of Beer</a> collection.</p>
<p>The Hello World Collection, started in 1994, was compiled 
with help from <a href="#credits">many people around the world</a>. It is
the biggest collection of Hello World programs on the Internet,
and the only one collecting human languages as well. To contribute,
send your program to <a href="mailto:info@helloworldcollection.de">info@helloworldcollection.de</a>.
Begin your contribution with a comment in the respective language.
<a href="http://en.wikipedia.org/wiki/Turing_completeness">Real</a> programming languages only please.</p>
<p>Click <a href="#credits">here</a> for a list of all contributors and other sources.<br>
Click <a href="#links">here</a> for related links.<br>
Click <a href="#history">here</a> for brief history of the Hello World Collection.<br>
Support the <a href="https://edu.kde.org">KDE Education Project</a> with our exclusive <a href="https://www.freewear.org/?org=HelloWorld">Hello World merchandise</a> &mdash; T-shirts, mugs and more!</p>
<p>Last update: `LANG=En_US date "+%b %d, %Y"`.</p>
<div style="text-align:center">`cat fixed/sharingbuttons.htm`</div>
<hr>
<a name="index"></a>
<h2>Index</h2>
<p>The latest additions are shown in <b>bold</b>.</p>
<p style="font-size: small;">
!

# Index ausgeben
cat $IDX >>$OUT
echo '</p>' >>$OUT

# Sourcecodes ausgeben
echo "Erzeuge Eintraege ..." >&2
for i in $(ls files/* | sort -f);do

  if [[ $i = *.htm ]];then
    ID=`basename $i .htm`
  else
    ID=`basename $i .txt`
  fi
  echo -e "$ID \c" >&2

  echo "<a name=\"$ID\"></a>"
  echo "<table width=\"100%\"><tr>"
  echo "<td><h2>$ID</h2></td>"
  echo "<td align=\"right\" width=\"1%\"><small><a href=\"#index\">Back&nbsp;to&nbsp;index</a></small></td>"
  echo "</tr></table>"
  
  if [[ $i = *.htm ]];then
    cat $i
  else
    echo "<pre>"
    sed <$i \
      -e 's/\&/\&amp;/g' \
      -e 's/</\&lt;/g' \
      -e 's/>/\&gt;/g'
    echo "</pre>"
  fi
done >>$OUT

# Credits anfügen
echo >&2
echo "Erzeuge Credits ..." >&2
echo "<hr><a name=\"credits\"></a><h2>Credits And Sources</h2>" >>$OUT
echo "<p>Programs were contributed by (in chronological order):</p>" >>$OUT
echo '<p style="font-size:xx-small;font-style:italic;">' >>$OUT
echo 'Wolfram R&ouml;sler: Founder and maintainer of the Collection' >>$OUT
sed 's/^/ \&mdash; /g' <contrib.txt >>$OUT
echo "</p>" >>$OUT

echo "<p>Programs were taken from these Internet sources:</p>" >>$OUT
echo '<p style="font-size:xx-small;font-style:italic;">' >>$OUT

first=1
cat sources.txt \
| while read name;do
  read lang || break

  if ((first));then
    first=0
  else
    echo " &mdash; "
  fi
  echo "<a href=\"$name\">$lang</a>"
done >>$OUT
echo "</p>" >>$OUT

# Links anfügen
echo "Erzeuge Links ..." >&2
echo "<hr><a name=\"links\"></a><h2>Hello World Links</h2><p>" >>$OUT
cat links.htm >>$OUT

# History anfügen
echo "Erzeuge History ..." >&2
echo "<hr><a name=\"history\"></a><h2>The History of the Hello World Collection</h2><p>" >>$OUT
cat history.htm >>$OUT

# HTML-Datei abschließen
cat >>$OUT <<!
<p style="text-align: right;">
<a href="http://validator.w3.org/check?uri=https://dl.dropboxusercontent.com/u/35009598/helloworld/index.htm"><img
src="http://www.w3.org/Icons/valid-html401" alt="Valid HTML 4.01 Transitional" height="31" width="88"></a>
</p>
</div>
</body>
</html>
!

# Bilder kopieren
rm -fr $OUTDIR/hellopics
mkdir $OUTDIR/hellopics
cp -pr hellopics/* $OUTDIR/hellopics

# Feste Dateien hinzukopieren
cp -p fixed/* $OUTDIR

# Aufräumen
rm -f $TOC $IDX $NEW

open $OUT
echo
echo "ENTER = online stellen, ^C = Abbruch"
read

ONLINE=$DROPBOX/Public/helloworld
rm -fr $ONLINE.prev
mv $ONLINE $ONLINE.prev
cp -pr $OUTDIR $ONLINE

echo -n "Fertig "
sleep 3
echo "und online!"
open http://helloworldcollection.de

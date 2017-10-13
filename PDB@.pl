#################################################
#####    Usage of various modules in perl    #####
##################################################
use Tk;
use WWW::Mechanize;
use Tk::Checkbutton;
use Tk::BrowseEntry;
use Tk::TableMatrix;
use Tk::TableMatrix::Spreadsheet; 
use Tk::Table;
use Tk::LabFrame;
use List::Util qw(max);
use List::Util qw(min);
#use Bio::Structure::IO;
##################################################################
#####    Main window opening and the various menu options    #####
##################################################################
$mw_ppp = MainWindow->new(-title=>'PDB@');
$mw_ppp->geometry(($mw_ppp->maxsize())[0] .'x'.($mw_ppp->maxsize())[0]);
$fm_menu = $mw_ppp->Frame(-relief=>'groove',-borderwidth=>5);
$fm_menu->pack(-side=>'top',-expand=>0,-fill=>'x');
$mn_ttys = $fm_menu->Menubutton(-text=>'                                   Open PDB  ',-menuitems=>[
['command'=>'Upload Your PDB File',-command=>\&load,-background=>"black",-foreground=>"white"],
['command'=>'FAST PDB',-command=>\&fpdb,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-text=>'  Miscelleneous Properties  ',-menuitems=>[
['command'=>'Display Secondary Structures of your PDB file',-command=>\&st,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-text=>'  Graphical Viewer  ',-menuitems=>[
['command'=>'View the various properties graphically',-command=>\&gv,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-text=>'  Utilities  ',-menuitems=>[
['command'=>'Use the various utilities of PDB@',-command=>\&stp,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_sec = $fm_menu->Menubutton(-text=>'  Property Calculations  ',-menuitems=>[
['command'=>'Calculate various properties of your PDB file',-command=>\&otc,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_fc = $fm_menu->Menubutton(-text=>'  Ramachandran Explorer  ',-menuitems=>[
['command'=>'Ramachandran Plot',-command=>\&rplot,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_fc = $fm_menu->Menubutton(-text=>'  PDB Editor  ',-menuitems=>[
['command'=>'Edit your desired PDB file',-command=>\&editor,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_of = $fm_menu->Menubutton(-text=>'  Original File  ',-menuitems=>[
['command'=>'Display Your Original File',-command=>\&ofile,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white")->pack(-side=>'left');
$mn_help = $fm_menu->Menubutton(-text=>'  Documentation                                ',-menuitems=>[
['command'=>'Explain about PDB@',-command=>\&show_help,-background=>"black",-foreground=>"white"]],-font=>[-size =>'10'],-background=>"black",-foreground=>"white");
$mn_help->pack(-side=>'left');
($help_about = <<EOHD) =~ s/^\t//gm;
Copyright (c) 2012 @ SASTRA University by Sadhana Ravishankar and Sai Mukund.R guided by Ast.Prof. Uday Kumar. M. 

This is an intergrated Protein analysis software being developed using Perl Tk.


                        The methods of using the tool   

First the PDB file is to be uploaded, and then the following options can be used

I  After loading the PDB file:

1. Displays the input PDB file.
2. ClustalW alignment for the chains of the PDB file.
3. Amino Acid statistics.

II Miscellaneous Properties:

1. Helix.
2. Sheet.
3. Selector.
4. Hetratom.
5. FASTA Converter.

III Graphical Viewer:

1. Heat Map.
2. Dot Plot.
3. Property Graph.
4. Hydrophobicity Graph.
5. Mobility Graph

IV Utilities:

1. RMSD for conformers.
2. PSA Calculator.
3. Protein - Ligand Distance.

V Property Calculation:

1. Interactions.
2. Distance Calculation.
3. Ligand Distance.
4. Region Separator.

VI Ramachandran Explorer

VII PDB Editor
EOHD
sub show_help 
{
$mw_help = MainWindow->new(-title=>'Tool Guide');
$mw_help->geometry(($mw_help->maxsize())[0] .'x'.($mw_help->maxsize())[1]);
my $fm_help = $mw_help->Frame(-relief=>'flat',-borderwidth=>5);
my $tx_help = $fm_help->Scrolled('Text');
$tx_help->pack(-side=>'top',-expand=>1,-fill=>'both');
$fm_help->pack(-side=>'top',-expand=>1,-fill=>'both');
$tx_help->insert('end', $help_about);
MainLoop;
}
#########################################################
#####    Various frames of the tools is declared    #####
#########################################################
$fm_dirs = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$txt=$fm_dirs->Text(-height=>20)->pack(-side=>'left',-expand=>1,-fill=>'both');
$txt1=$fm_dirs->Text(-height=>20)->pack(-side=>'left',-expand=>1,-fill=>'both');
$fm_dirs->pack(-side=>'top',-expand=>0,-fill=>'both');
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1 = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
#########################################################
#####      Using bind command for shortcut keys     #####
#########################################################
$mw_ppp-> bind('<Control-Key-o>',sub {load();});
$mw_ppp-> bind('<Control-Key-e>',sub {editor();});
$mw_ppp-> bind('<Control-Key-g>',sub {gv();});
$mw_ppp-> bind('<Control-Key-s>',sub {stp();});
$mw_ppp-> bind('<Control-Key-r>',sub {rplot();});
$mw_ppp-> bind('<Control-Key-m>',sub {st();});
MainLoop;
#########################################################
#####    Main execution program starts from here    #####
#########################################################


##################################################
#####    Openging of the PDB file to display #####
#####          the main proerties            #####
##################################################
sub load
{
$m=$mw_ppp->getOpenFile();
$mm=$m;
if($m ne "")
{
open(CL,"count.pl");
@c=<CL>;
$hit=$c[0];
close CL;
open(CLS,">count.pl");
$hit++;
print CLS $hit;
close CLS;
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$txt1->delete('1.0','end');
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
open(FH,$m);
$op="";
$m1="";
while(<FH>)
{
if($_=~/^HEADER/)
{
$m1=substr($_,62,4);
}
$op.=$_.$linst;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=(21,8);
foreach my $row (0..($rows-1))
{
$arrayVar->{"$row,0"} = "$row";
}
$arrayVar->{"0,0"} = "S.No";
$arrayVar->{"0,1"} = "Residue";
$arrayVar->{"0,2"} = "Composition";
$arrayVar->{"0,3"} = "Mol. Weight";
$arrayVar->{"0,4"} = "Position";
$arrayVar->{"0,5"} = "X co-or summation";
$arrayVar->{"0,6"} = "Y co-or summation";
$arrayVar->{"0,7"} = "Z co-or summation";
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 3,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,2); 
$t->tagRow('title',0); 
$t->activate("1,0"); 
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$t->pack(-expand => 1, -fill => 'both');
$t->focus;
$t->colWidth(2=>10,1=>10,0=>10,3=>20,4=>100,5=>20,6=>20);
open(DESC,$m);
@res=();
@final=();
@atomres=();
@output=();
while(<DESC>)
{
if($_=~/^ATOM/)
{
push(@res,substr($_,17,3));
push(@atomres,substr($_,23,3));
}
}
close DESC;
for($i=0;$i<scalar(@atomres);$i++)
{
for($j=$i+1;$j<scalar(@atomres);$j++)
{
if($atomres[$i] eq $atomres[$j])
{
next;
}
else
{
push(@final,$res[$i]);
$i=$j;
last;
}
}
}
push(@final,$res[$#res]);
for($i=0;$i<scalar(@final);$i++)
{
if($final[$i] eq 'GLY')
{
$one++;
}
if($final[$i] eq 'ALA')
{
$two++;
}
if($final[$i] eq 'PHE')
{  
$three++;
}
if($final[$i] eq 'VAL')
{
$four++;
}
if($final[$i] eq 'LEU')
{
$five++;
}
if($final[$i] eq 'ILE')
{
$six++;
}
if($final[$i] eq 'SER')
{
$seven++;
}
if($final[$i] eq 'THR')
{
$eight++;
}
if($final[$i] eq 'CYS')
{
$nine++;
}
if($final[$i] eq 'MET')
{
$ten++;
}
if($final[$i] eq 'ASP')
{
$eleven++;
}
if($final[$i] eq 'GLU')
{
$twelve++;
}
if($final[$i] eq 'ASN')
{
$thirteen++;
}
if($final[$i] eq 'GLN')
{
$fourteen++;
}
if($final[$i] eq 'LYS')
{
$fifteen++;
}
if($final[$i] eq 'TYR')
{
$sixteen++;
}
if($final[$i] eq 'TRP')
{
$seventeen++;
}
if($final[$i] eq 'HIS')
{
$eighteen++;
}
if($final[$i] eq 'PRO')
{
$nineteen++;
}
if($final[$i] eq 'ARG')
{
$twenty++;
}
}
@molwt=();
push(@output,$one);
push(@output,$two);
push(@output,$three);
push(@output,$four);
push(@output,$five);
push(@output,$six);
push(@output,$seven);
push(@output,$eight);
push(@output,$nine);
push(@output,$ten);
push(@output,$eleven);
push(@output,$twelve);
push(@output,$thirteen);
push(@output,$fourteen);
push(@output,$fifteen);
push(@output,$sixteen);
push(@output,$seventeen);
push(@output,$eighteen);
push(@output,$nineteen);
push(@output,$twenty);
$one1=$one*75.0669;
$two1=$two*89.0935;
$three1=$three*165.1900;
$four1=$four*117.1469;
$five1=$five*146.1882;
$six1=$six*131.1736;
$seven1=$seven*105.0930;
$eight1=$eight*119.1197;
$nine1=$nine*121.1590;
$ten1=$ten*149.2124;
$eleven1=$eleven*133.1032;
$twelve1=$twelve*147.1299;
$thirteen1=$thirteen*132.1184;
$fourteen1=$fourteen*146.1451;
$fifteen1=$fifteen*146.1882;
$sixteen1=$sixteen*181.1894;
$seventeen1=$seventeen*204.2262;
$eighteen1=$eighteen*155.1552;
$nineteen1=$nineteen*115.1310;
$twenty1=$twenty*174.2017;
push(@molwt,$one1);
push(@molwt,$two1);
push(@molwt,$three1);
push(@molwt,$four1);
push(@molwt,$five1);
push(@molwt,$six1);
push(@molwt,$seven1);
push(@molwt,$eight1);
push(@molwt,$nine1);
push(@molwt,$ten1);
push(@molwt,$eleven1);
push(@molwt,$twelve1);
push(@molwt,$thirteen1);
push(@molwt,$fourteen1);
push(@molwt,$fifteen1);
push(@molwt,$sixteen1);
push(@molwt,$seventeen1);
push(@molwt,$eighteen1);
push(@molwt,$nineteen1);
push(@molwt,$twenty1);
@name=qw(SNo. Residue Composition Mol.Weight);
$i=0;
@amio=qw(GLY ALA PHE VAL LEU ILE SER THR CYS MET ASP GLU ASN GLN LYS TYR TRP HIS PRO ARG);
open(POO,$m);
@resg=();
@atomresg=();
@finalg=();
@finalatomresg=();
while(<POO>)
{
if($_=~/^ATOM/)
{
push(@resg,substr($_,17,3));
push(@atomresg,substr($_,23,3));
}
}
close POO;
for($i=0;$i<scalar(@atomresg);$i++)
{
for($j=$i+1;$j<scalar(@atomresg);$j++)
{
if($atomresg[$i] eq $atomresg[$j])
{
next;
}
else
{
push(@finalg,$resg[$i]);
push(@finalatomresg,$atomresg[$i]);
$i=$j;
last;
}
}
}
push(@finalg,$resg[$#resg]);
push(@finalatomresg,$atomresg[$#atomresg]);
@positon=();
for($z=0;$z<scalar(@finalg);$z++)
{
if($finalg[$z] eq 'GLY')
{
$positon[0][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ALA')
{
$positon[1][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'PHE')
{  
$positon[2][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'VAL')
{
$positon[3][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'LEU')
{
$positon[4][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ILE')
{
$positon[5][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'SER')
{
$positon[6][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'THR')
{
$positon[7][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'CYS')
{
$positon[8][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'MET')
{
$positon[9][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ASP')
{
$positon[10][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'GLU')
{
$positon[11][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ASN')
{
$positon[12][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'GLN')
{
$positon[13][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'LYS')
{
$positon[14][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'TYR')
{
$positon[15][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'TRP')
{
$positon[16][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'HIS')
{
$positon[17][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'PRO')
{
$positon[18][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ARG')
{
$positon[19][0].=$finalatomresg[$z]."-";
}
}
open(SUMM,$m);
@di=();
while(<SUMM>)
{
if($_=~/^ATOM/)
{
push(@di,$_);
}
}
close SUMM;
@x=();
@y=();
@z=();
for($i=0;$i<scalar(@di);$i++)
{
if(substr($di[$i],17,3) eq "GLY")
{
$x[0][0]+=substr($di[$i],31,7);
$y[0][0]+=substr($di[$i],39,7);
$z[0][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ALA")
{
$x[1][0]+=substr($di[$i],31,7);
$y[1][0]+=substr($di[$i],39,7);
$z[1][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "PHE")
{
$x[2][0]+=substr($di[$i],31,7);
$y[2][0]+=substr($di[$i],39,7);
$z[2][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "VAL")
{
$x[3][0]+=substr($di[$i],31,7);
$y[3][0]+=substr($di[$i],39,7);
$z[3][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "LEU")
{
$x[4][0]+=substr($di[$i],31,7);
$y[4][0]+=substr($di[$i],39,7);
$z[4][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ILE")
{
$x[5][0]+=substr($di[$i],31,7);
$y[5][0]+=substr($di[$i],39,7);
$z[5][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "SER")
{
$x[6][0]+=substr($di[$i],31,7);
$y[6][0]+=substr($di[$i],39,7);
$z[6][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "THR")
{
$x[7][0]+=substr($di[$i],31,7);
$y[7][0]+=substr($di[$i],39,7);
$z[7][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "CYS")
{
$x[8][0]+=substr($di[$i],31,7);
$y[8][0]+=substr($di[$i],39,7);
$z[8][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "MET")
{
$x[9][0]+=substr($di[$i],31,7);
$y[9][0]+=substr($di[$i],39,7);
$z[9][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ASP")
{
$x[10][0]+=substr($di[$i],31,7);
$y[10][0]+=substr($di[$i],39,7);
$z[10][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "GLU")
{
$x[11][0]+=substr($di[$i],31,7);
$y[11][0]+=substr($di[$i],39,7);
$z[11][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ASN")
{
$x[12][0]+=substr($di[$i],31,7);
$y[12][0]+=substr($di[$i],39,7);
$z[12][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "GLN")
{
$x[13][0]+=substr($di[$i],31,7);
$y[13][0]+=substr($di[$i],39,7);
$z[13][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "LYS")
{
$x[14][0]+=substr($di[$i],31,7);
$y[14][0]+=substr($di[$i],39,7);
$z[14][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "TYR")
{
$x[15][0]+=substr($di[$i],31,7);
$y[15][0]+=substr($di[$i],39,7);
$z[15][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "TRP")
{
$x[16][0]+=substr($di[$i],31,7);
$y[16][0]+=substr($di[$i],39,7);
$z[16][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "HIS")
{
$x[17][0]+=substr($di[$i],31,7);
$y[17][0]+=substr($di[$i],39,7);
$z[17][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "PRO")
{
$x[18][0]+=substr($di[$i],31,7);
$y[18][0]+=substr($di[$i],39,7);
$z[18][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ARG")
{
$x[19][0]+=substr($di[$i],31,7);
$y[19][0]+=substr($di[$i],39,7);
$z[19][0]+=substr($di[$i],47,7);
}
}
$x=0;
foreach my $row(1..20)
{
foreach my $col(5)
{
$x[$x][0]=round($x[$x][0],3);
$arrayVar->{"$row,$col"} = $x[$x][0];
}
$x++;
}
$y=0;
foreach my $row(1..20)
{
foreach my $col(6)
{
$y[$y][0]=round($y[$y][0],3);
$arrayVar->{"$row,$col"} = $y[$y][0];
}
$y++;
}
$z=0;
foreach my $row(1..20)
{
foreach my $col(7)
{
$z[$z][0]=round($z[$z][0],3);
$arrayVar->{"$row,$col"} = $z[$z][0];
}
$z++;
}
$d=0;
foreach my $row(1..20)
{
foreach my $col(4)
{chop($positon[$d][0]);
$arrayVar->{"$row,$col"} = $positon[$d][0];
}
$d++;
}
$i=0;
@amio=qw(GLY ALA PHE VAL LEU ILE SER THR CYS MET ASP GLU ASN GLN LYS TYR TRP HIS PRO ARG);
foreach my $row(1..$rows)
{
foreach my $col(1)
{
$arrayVar->{"$row,$col"} = $amio[$i];
}
$i++;
}
$j=0;
foreach my $row(1..$rows)
{
foreach my $col(2)
{
$arrayVar->{"$row,$col"} = $output[$j];
}
$j++;
}
$k=0;
foreach my $row(1..$rows)
{
foreach my $col(3)
{
$arrayVar->{"$row,$col"} =$molwt[$k];
}
$k++;
}
open(CLU,$m);
open(CLUS,">clustal$hit.fasta");
%amino=(
'ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E',
'GLN'=>'Q','GLY'=>'G','HIS'=>'H','ILE'=>'I','LEU'=>'L','LYS'=>'K',
'MET'=>'M','PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W',
'TYR'=>'Y','VAL'=>'V');
@cc=();
@chainsc=();
@clustalw=();
while(<CLU>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@cc=split(/,/,$_);
push(@chainsc,@cc);
}
}
}
close CLU;
open(SS,$m);
@file=();
while(<SS>)
{
push(@file,$_);
}
close SS;
for($c=0;$c<scalar(@chainsc);$c++)
{
@resc=();
@atomc=();
@finalc=();
for($r=0;$r<scalar(@file);$r++)
{
if($file[$r]=~/^ATOM/)
{
if(substr($file[$r],21,1) eq $chainsc[$c])
{
push(@resc,substr($file[$r],17,3));
push(@atomc,substr($file[$r],23,3));
}
}
}
for($i=0;$i<scalar(@atomc);$i++)
{
for($j=$i+1;$j<scalar(@atomc);$j++)
{
if($atomc[$i] eq $atomc[$j])
{
next;
}
else
{
push(@finalc,$resc[$i]);
$i=$j;
last;
}
}
}
push(@finalc,$resc[$#resc]);
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
for($z=0;$z<scalar(@finalc);$z++)
{
$clustalw[$c].=$amino{$finalc[$z]};
}
}
for($e=0;$e<scalar(@clustalw);$e++)
{
print CLUS ">$m1|Chain:$chainsc[$e]\n$clustalw[$e]";
print CLUS "\n";
}
close CLUS;
$opc=`clustalw clustal$hit.fasta`;
$txt1->delete('1.0','end');
$txt1->tag(qw/configure color1 -background red/);
$txt1->tag(qw/configure color2 -background blue/);
$txt1->tag(qw/configure color3 -background pink/);
$txt1->tag(qw/configure color4 -background green/);
$txt1->tag(qw/configure color5 -background grey/);
open(UKAR,"clustal$hit.aln");
@ukar=();
$color="";
while(<UKAR>)
{
if($_=~/^CLUSTAL/)
{
next;
}
push(@ukar,$_);
}
close UKAR;
$d="";
$d.="The Multiple Chain Alignment"."\n"."\n";
$txt1->insert('insert',$d);
for($i=0;$i<scalar(@ukar);$i++)
{
$gems=substr($ukar[$i],0,18);
$txt1->insert('insert',$gems);
for($j=0;$j<length($ukar[$i]);$j++)
{
if((substr($ukar[$i],18+$j,1) eq "A") || (substr($ukar[$i],18+$j,1) eq "V") || (substr($ukar[$i],18+$j,1) eq "F" ) || (substr($ukar[$i],18+$j,1) eq "P") || (substr($ukar[$i],18+$j,1) eq "M") || (substr($ukar[$i],18+$j,1) eq "I") || (substr($ukar[$i],18+$j,1) eq "L") || (substr($ukar[$i],18+$j,1) eq "W"))
{
$chc1=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc1,'color1');
}
elsif((substr($ukar[$i],18+$j,1) eq "D") || (substr($ukar[$i],18+$j,1) eq "E"))
{
$chc2=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc2,'color2');
}
elsif((substr($ukar[$i],18+$j,1) eq "R") || (substr($ukar[$i],18+$j,1) eq "H") || (substr($ukar[$i],18+$j,1) eq "K" ))
{
$chc3=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc3,'color3');
}
elsif((substr($ukar[$i],18+$j,1) eq "S") || (substr($ukar[$i],18+$j,1) eq "T") || (substr($ukar[$i],18+$j,1) eq "Y" ) || (substr($ukar[$i],18+$j,1) eq "H") || (substr($ukar[$i],18+$j,1) eq "C") || (substr($ukar[$i],18+$j,1) eq "N") || (substr($ukar[$i],18+$j,1) eq "G") || (substr($ukar[$i],18+$j,1) eq "Q"))
{
$chc4=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc4,'color4');
}
else
{
$chc5=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc5);
}
}
}
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
##################################################
#####    Display the original file once any  #####
#####		     calculation is done         #####
##################################################
sub ofile
{
if($m ne "")
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
open(FH,$m);
$op="";
while(<FH>)
{
$op.=$_;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
$txt1->delete('1.0','end');
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=(21,8);
foreach my $row (0..($rows-1))
{
$arrayVar->{"$row,0"} = "$row";
}
$arrayVar->{"0,0"} = "S.No";
$arrayVar->{"0,1"} = "Residue";
$arrayVar->{"0,2"} = "Composition";
$arrayVar->{"0,3"} = "Mol. Weight";
$arrayVar->{"0,4"} = "Position";
$arrayVar->{"0,5"} = "X co-or summation";
$arrayVar->{"0,6"} = "Y co-or summation";
$arrayVar->{"0,7"} = "Z co-or summation";
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 3,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,2); 
$t->tagRow('title',0); 
$t->activate("1,0"); 
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$t->pack(-expand => 1, -fill => 'both');
$t->focus;
$t->colWidth(2=>10,1=>10,0=>10,3=>20,4=>100,5=>20,6=>20);
open(DESC,$m);
@res=();
@final=();
@atomres=();
@output=();
while(<DESC>)
{
if($_=~/^ATOM/)
{
push(@res,substr($_,17,3));
push(@atomres,substr($_,23,3));
}
}
close DESC;
for($i=0;$i<scalar(@atomres);$i++)
{
for($j=$i+1;$j<scalar(@atomres);$j++)
{
if($atomres[$i] eq $atomres[$j])
{
next;
}
else
{
push(@final,$res[$i]);
$i=$j;
last;
}
}
}
push(@final,$res[$#res]);
for($i=0;$i<scalar(@final);$i++)
{
if($final[$i] eq 'GLY')
{
$one++;
}
if($final[$i] eq 'ALA')
{
$two++;
}
if($final[$i] eq 'PHE')
{  
$three++;
}
if($final[$i] eq 'VAL')
{
$four++;
}
if($final[$i] eq 'LEU')
{
$five++;
}
if($final[$i] eq 'ILE')
{
$six++;
}
if($final[$i] eq 'SER')
{
$seven++;
}
if($final[$i] eq 'THR')
{
$eight++;
}
if($final[$i] eq 'CYS')
{
$nine++;
}
if($final[$i] eq 'MET')
{
$ten++;
}
if($final[$i] eq 'ASP')
{
$eleven++;
}
if($final[$i] eq 'GLU')
{
$twelve++;
}
if($final[$i] eq 'ASN')
{
$thirteen++;
}
if($final[$i] eq 'GLN')
{
$fourteen++;
}
if($final[$i] eq 'LYS')
{
$fifteen++;
}
if($final[$i] eq 'TYR')
{
$sixteen++;
}
if($final[$i] eq 'TRP')
{
$seventeen++;
}
if($final[$i] eq 'HIS')
{
$eighteen++;
}
if($final[$i] eq 'PRO')
{
$nineteen++;
}
if($final[$i] eq 'ARG')
{
$twenty++;
}
}
@molwt=();
push(@output,$one);
push(@output,$two);
push(@output,$three);
push(@output,$four);
push(@output,$five);
push(@output,$six);
push(@output,$seven);
push(@output,$eight);
push(@output,$nine);
push(@output,$ten);
push(@output,$eleven);
push(@output,$twelve);
push(@output,$thirteen);
push(@output,$fourteen);
push(@output,$fifteen);
push(@output,$sixteen);
push(@output,$seventeen);
push(@output,$eighteen);
push(@output,$nineteen);
push(@output,$twenty);
$one1=$one*75.0669;
$two1=$two*89.0935;
$three1=$three*165.1900;
$four1=$four*117.1469;
$five1=$five*146.1882;
$six1=$six*131.1736;
$seven1=$seven*105.0930;
$eight1=$eight*119.1197;
$nine1=$nine*121.1590;
$ten1=$ten*149.2124;
$eleven1=$eleven*133.1032;
$twelve1=$twelve*147.1299;
$thirteen1=$thirteen*132.1184;
$fourteen1=$fourteen*146.1451;
$fifteen1=$fifteen*146.1882;
$sixteen1=$sixteen*181.1894;
$seventeen1=$seventeen*204.2262;
$eighteen1=$eighteen*155.1552;
$nineteen1=$nineteen*115.1310;
$twenty1=$twenty*174.2017;
push(@molwt,$one1);
push(@molwt,$two1);
push(@molwt,$three1);
push(@molwt,$four1);
push(@molwt,$five1);
push(@molwt,$six1);
push(@molwt,$seven1);
push(@molwt,$eight1);
push(@molwt,$nine1);
push(@molwt,$ten1);
push(@molwt,$eleven1);
push(@molwt,$twelve1);
push(@molwt,$thirteen1);
push(@molwt,$fourteen1);
push(@molwt,$fifteen1);
push(@molwt,$sixteen1);
push(@molwt,$seventeen1);
push(@molwt,$eighteen1);
push(@molwt,$nineteen1);
push(@molwt,$twenty1);
@name=qw(SNo. Residue Composition Mol.Weight);
open(POO,$m);
@resg=();
@atomresg=();
@finalg=();
@finalatomresg=();
while(<POO>)
{
if($_=~/^ATOM/)
{
push(@resg,substr($_,17,3));
push(@atomresg,substr($_,23,3));
}
}
close POO;
for($i=0;$i<scalar(@atomresg);$i++)
{
for($j=$i+1;$j<scalar(@atomresg);$j++)
{
if($atomresg[$i] eq $atomresg[$j])
{
next;
}
else
{
push(@finalg,$resg[$i]);
push(@finalatomresg,$atomresg[$i]);
$i=$j;
last;
}
}
}
push(@finalg,$resg[$#resg]);
push(@finalatomresg,$atomresg[$#atomresg]);
@positon=();
for($z=0;$z<scalar(@finalg);$z++)
{
if($finalg[$z] eq 'GLY')
{
$positon[0][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ALA')
{
$positon[1][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'PHE')
{  
$positon[2][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'VAL')
{
$positon[3][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'LEU')
{
$positon[4][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ILE')
{
$positon[5][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'SER')
{
$positon[6][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'THR')
{
$positon[7][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'CYS')
{
$positon[8][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'MET')
{
$positon[9][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ASP')
{
$positon[10][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'GLU')
{
$positon[11][0].=$finalatomresg[$z]." -";
}
if($finalg[$z] eq 'ASN')
{
$positon[12][0].=$finalatomresg[$z]." -";
}
if($finalg[$z] eq 'GLN')
{
$positon[13][0].=$finalatomresg[$z]."--";
}
if($finalg[$z] eq 'LYS')
{
$positon[14][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'TYR')
{
$positon[15][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'TRP')
{
$positon[16][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'HIS')
{
$positon[17][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'PRO')
{
$positon[18][0].=$finalatomresg[$z]."-";
}
if($finalg[$z] eq 'ARG')
{
$positon[19][0].=$finalatomresg[$z]."-";
}
}
open(SUMM,$m);
@di=();
while(<SUMM>)
{
if($_=~/^ATOM/)
{
push(@di,$_);
}
}
close SUMM;
@x=();
@y=();
@z=();
for($i=0;$i<scalar(@di);$i++)
{
if(substr($di[$i],17,3) eq "GLY")
{
$x[0][0]+=substr($di[$i],31,7);
$y[0][0]+=substr($di[$i],39,7);
$z[0][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ALA")
{
$x[1][0]+=substr($di[$i],31,7);
$y[1][0]+=substr($di[$i],39,7);
$z[1][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "PHE")
{
$x[2][0]+=substr($di[$i],31,7);
$y[2][0]+=substr($di[$i],39,7);
$z[2][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "VAL")
{
$x[3][0]+=substr($di[$i],31,7);
$y[3][0]+=substr($di[$i],39,7);
$z[3][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "LEU")
{
$x[4][0]+=substr($di[$i],31,7);
$y[4][0]+=substr($di[$i],39,7);
$z[4][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ILE")
{
$x[5][0]+=substr($di[$i],31,7);
$y[5][0]+=substr($di[$i],39,7);
$z[5][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "SER")
{
$x[6][0]+=substr($di[$i],31,7);
$y[6][0]+=substr($di[$i],39,7);
$z[6][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "THR")
{
$x[7][0]+=substr($di[$i],31,7);
$y[7][0]+=substr($di[$i],39,7);
$z[7][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "CYS")
{
$x[8][0]+=substr($di[$i],31,7);
$y[8][0]+=substr($di[$i],39,7);
$z[8][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "MET")
{
$x[9][0]+=substr($di[$i],31,7);
$y[9][0]+=substr($di[$i],39,7);
$z[9][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ASP")
{
$x[10][0]+=substr($di[$i],31,7);
$y[10][0]+=substr($di[$i],39,7);
$z[10][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "GLU")
{
$x[11][0]+=substr($di[$i],31,7);
$y[11][0]+=substr($di[$i],39,7);
$z[11][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ASN")
{
$x[12][0]+=substr($di[$i],31,7);
$y[12][0]+=substr($di[$i],39,7);
$z[12][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "GLN")
{
$x[13][0]+=substr($di[$i],31,7);
$y[13][0]+=substr($di[$i],39,7);
$z[13][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "LYS")
{
$x[14][0]+=substr($di[$i],31,7);
$y[14][0]+=substr($di[$i],39,7);
$z[14][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "TYR")
{
$x[15][0]+=substr($di[$i],31,7);
$y[15][0]+=substr($di[$i],39,7);
$z[15][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "TRP")
{
$x[16][0]+=substr($di[$i],31,7);
$y[16][0]+=substr($di[$i],39,7);
$z[16][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "HIS")
{
$x[17][0]+=substr($di[$i],31,7);
$y[17][0]+=substr($di[$i],39,7);
$z[17][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "PRO")
{
$x[18][0]+=substr($di[$i],31,7);
$y[18][0]+=substr($di[$i],39,7);
$z[18][0]+=substr($di[$i],47,7);
}
if(substr($di[$i],17,3) eq "ARG")
{
$x[19][0]+=substr($di[$i],31,7);
$y[19][0]+=substr($di[$i],39,7);
$z[19][0]+=substr($di[$i],47,7);
}
}
$x=0;
foreach my $row(1..20)
{
foreach my $col(5)
{
$x[$x][0]=round($x[$x][0],3);
$arrayVar->{"$row,$col"} = $x[$x][0];
}
$x++;
}
$y=0;
foreach my $row(1..20)
{
foreach my $col(6)
{
$y[$y][0]=round($y[$y][0],3);
$arrayVar->{"$row,$col"} = $y[$y][0];
}
$y++;
}
$z=0;
foreach my $row(1..20)
{
foreach my $col(7)
{
$z[$z][0]=round($z[$z][0],3);
$arrayVar->{"$row,$col"} = $z[$z][0];
}
$z++;
}
$d=0;
foreach my $row(1..20)
{
foreach my $col(4)
{chop($positon[$d][0]);
$arrayVar->{"$row,$col"} = $positon[$d][0];
}
$d++;
}
$i=0;
@amio=qw(GLY ALA PHE VAL LEU ILE SER THR CYS MET ASP GLU ASN GLN LYS TYR TRP HIS PRO ARG);
foreach my $row(1..$rows)
{
foreach my $col(1)
{
$arrayVar->{"$row,$col"} = $amio[$i];
}
$i++;
}
$j=0;
foreach my $row(1..$rows)
{
foreach my $col(2)
{
$arrayVar->{"$row,$col"} = $output[$j];
}
$j++;
}
$k=0;
foreach my $row(1..$rows)
{
foreach my $col(3)
{
$arrayVar->{"$row,$col"} =$molwt[$k];
}
$k++;
}
open(CLU,$m);
open(CLUS,">clustal$hit.fasta");
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
@cc=();
@chainsc=();
@clustalw=();
while(<CLU>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@cc=split(/,/,$_);
push(@chainsc,@cc);
}
}
}
close CLU;
open(SS,$m);
@file=();
while(<SS>)
{
push(@file,$_);
}
close SS;
for($c=0;$c<scalar(@chainsc);$c++)
{
@resc=();
@atomc=();
@finalc=();
for($r=0;$r<scalar(@file);$r++)
{
if($file[$r]=~/^ATOM/)
{
if(substr($file[$r],21,1) eq $chainsc[$c])
{
push(@resc,substr($file[$r],17,3));
push(@atomc,substr($file[$r],23,3));
}
}
}
for($i=0;$i<scalar(@atomc);$i++)
{
for($j=$i+1;$j<scalar(@atomc);$j++)
{
if($atomc[$i] eq $atomc[$j])
{
next;
}
else
{
push(@finalc,$resc[$i]);
$i=$j;
last;
}
}
}
push(@finalc,$resc[$#resc]);
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
for($z=0;$z<scalar(@finalc);$z++)
{
$clustalw[$c].=$amino{$finalc[$z]};
}
}
for($e=0;$e<scalar(@clustalw);$e++)
{
print CLUS ">$m1|Chain:$chainsc[$e]\n$clustalw[$e]";
print CLUS "\n";
}
close CLUS;
$opc=`clustalw clustal$hit.fasta`;
$txt1->delete('1.0','end');
$txt1->tag(qw/configure color1 -background red/);
$txt1->tag(qw/configure color2 -background blue/);
$txt1->tag(qw/configure color3 -background pink/);
$txt1->tag(qw/configure color4 -background green/);
$txt1->tag(qw/configure color5 -background grey/);
open(UKAR,"clustal$hit.aln");
@ukar=();
$color="";
while(<UKAR>)
{
if($_=~/^CLUSTAL/)
{
next;
}
push(@ukar,$_);
}
close UKAR;
$d="";
$d.="The Multiple Chain Alignment"."\n";
$txt1->insert('insert',$d);
for($i=0;$i<scalar(@ukar);$i++)
{
$gems=substr($ukar[$i],0,18);
$txt1->insert('insert',$gems);
for($j=0;$j<length($ukar[$i]);$j++)
{
if((substr($ukar[$i],18+$j,1) eq "A") || (substr($ukar[$i],18+$j,1) eq "V") || (substr($ukar[$i],18+$j,1) eq "F" ) || (substr($ukar[$i],18+$j,1) eq "P") || (substr($ukar[$i],18+$j,1) eq "M") || (substr($ukar[$i],18+$j,1) eq "I") || (substr($ukar[$i],18+$j,1) eq "L") || (substr($ukar[$i],18+$j,1) eq "W"))
{
$chc1=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc1,'color1');
}
elsif((substr($ukar[$i],18+$j,1) eq "D") || (substr($ukar[$i],18+$j,1) eq "E"))
{
$chc2=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc2,'color2');
}
elsif((substr($ukar[$i],18+$j,1) eq "R") || (substr($ukar[$i],18+$j,1) eq "H") || (substr($ukar[$i],18+$j,1) eq "K" ))
{
$chc3=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc3,'color3');
}
elsif((substr($ukar[$i],18+$j,1) eq "S") || (substr($ukar[$i],18+$j,1) eq "T") || (substr($ukar[$i],18+$j,1) eq "Y" ) || (substr($ukar[$i],18+$j,1) eq "H") || (substr($ukar[$i],18+$j,1) eq "C") || (substr($ukar[$i],18+$j,1) eq "N") || (substr($ukar[$i],18+$j,1) eq "G") || (substr($ukar[$i],18+$j,1) eq "Q"))
{
$chc4=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc4,'color4');
}
else
{
$chc5=substr($ukar[$i],18+$j,1);
$txt1->insert('insert',$chc5);
}
}
}
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
#############################
#############################st subroutine..... Does all the secondary structure classifications of the PDB file.
#1.Finding all the ATOM co-ordinates for the helical and sheet regions
#2.Extracting only the HETRATOM cordinates
#3.Calculation of Heat, Hyrdophobic, dot plots.
#4.Calculates all of the interactions required.
#############################
sub st
{
if($m ne "")
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
my $bn1_ppp_1 = $fm_look->Button(-relief=>'raised',-text=>"SHEETS",-command=>\&sheets,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
my $bn1_ppp_2 = $fm_look->Button(-relief=>'raised',-text=>"HELIX",-command=>\&helix,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
my $sai = $fm_look->Button(-relief=>'raised',-text=>"Selector",-command=>\&selector,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
my $sai1 = $fm_look->Button(-relief=>'raised',-text=>"HetraAtom",-command=>\&hetam,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
my $sai2 = $fm_look->Button(-relief=>'raised',-text=>"FASTA Converter",-command=>\&fast,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$bn1_ppp_1->pack(-side=>'left',-expand=>1,-fill=>'x');
$bn1_ppp_2->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai1->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai2->pack(-side=>'left',-expand=>1,-fill=>'x');
open(FH,$m);
$op="";
$m1="";
while(<FH>)
{
if($_=~/^HEADER/)
{
$m1=substr($_,62,4);
}
$op.=$_.$linst;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
sub hetam
{
$op13="";
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$txt1->insert('1.0',"hai");	
$txt1->delete('1.0','end');
open(FM,$m);
while(<FM>)
{
if($_=~/^HETATM/)
{
$op13.=$_;
}
}
close FM;
$txt->delete('1.0','end');
$txt->insert('1.0',$op13);
$down4=$fm_set->Button(-text=>"Download File",-command=>\&downloadhe)->pack(-side=>"top");
}
sub sheets
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);

$txt1->delete('1.0','end');
$op1="";
open(FM,$m);
while(<FM>)
{
if($_=~/^SHEET/)
{
$op1.=$_;
}
}

close FM;
$txt->delete('1.0','end');
$txt->insert('1.0',$op1);
@finish=();
@begin=();
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
my $dropdown_value;
my $dropdown = $fm_set->BrowseEntry(-label => "                                      				                                     From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(SAI,$m);
@finishs=();
@begins=();
while(<SAI>)
{
if($_=~/^SHEET/)
{
$start=substr($_,23,3);
push(@begins,$start);
$end=substr($_,34,3);
push(@finishs,$end);
}
}
close SAI;
foreach ( @begins) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_set->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach ( @finishs) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_set->Button(-text=>"Get Co-ordinates",-font=>[-size =>'10'],-command=>sub{$fs=$dropdown_value; 
$es=$dropdown_valueq;
ho($fs,$es)})->pack(-anchor=>'nw',-side=>'left');
$down2=$fm_set->Label(-text=>"        ")->pack(-anchor=>'nw',-side=>'left');
$down1=$fm_set->Button(-text=>"Download File",-command=>\&downloads,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
}
sub ho
{
@fpdbs=();
$pfiles="";
$helsingles="";
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my($start,$end)=@_;
open(CO,$m);
$op1="";
while(<CO>)
{
if($_=~/^ATOM/)
{
$ch=substr($_,23,3);
if($ch<=$end && $ch>=$start)
{
$op1.=$_;
}
}
}
close CO;
$txt->delete('1.0','end');
$txt->insert('1.0',$op1);
$pfiles=$txt->get('1.0','end');
@fpdbs=split(/\n/,$pfiles);
open(FG,$m);
@cs=();
@chainss=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@cs=split(/,/,$_);
push(@chainss,@cs);
}
}
}
close FG;
for(my $i=0;$i<scalar(@chainss);$i++)
{
$chas=$chainss[$i];
@helress=();
@helfinals=();
$helsingles.=">CHAIN-$chas|$start-$end residues:\n";
for(my $j=0;$j<scalar(@fpdbs);$j++)
{
$c1s=substr($fpdbs[$j],21,1);
if($chas eq $c1s)
{
push(@helress,substr($fpdbs[$j],17,3));
}
}
sheetres(@helress);
}	
}
sub sheetres
{
@helixs=();
@helfinals=();
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my(@helixs)=@_;
for($i=0;$i<scalar(@helixs);$i++)
{
for($j=$i+1;$j<scalar(@helixs);$j++)
{
if($helixs[$i] eq $helixs[$j])
{
next;
}
else
{
push(@helfinals,$helixs[$i]);
$i=$j;
last;
}
}
}
push(@helfinals,$helixs[$#helixs]);
for($i=0;$i<scalar(@helfinals);$i++)
{
$helsingles.=$amino{$helfinals[$i]};
}
$helsingles.="\n\n";
$txt1->delete('1.0','end');
$txt1->insert('1.0',$helsingles);
}
sub helix
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);

open(FM,$m);
$oph="";
while(<FM>)
{
if($_=~/^HELIX/)
{
$oph.=$_;
}
}
close FM;
$txt->delete('1.0','end');
$txt->insert('1.0',$oph);
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
my $dropdown_value;
my $dropdown = $fm_set->BrowseEntry(-label => "                   		                            		                             From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(FH,$m);
@finish=();
@begin=();
while(<FH>)
{
if($_=~/^HELIX/)
{
$start=substr($_,22,3);
push(@begin,$start);
$end=substr($_,34,3);
push(@finish,$end);
}
}
close FH;
foreach ( @begin) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_set->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach ( @finish ) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_set->Button(-text=>"Get Co-ordinates",-command=>sub{$f=$dropdown_value; 
$e=$dropdown_valueq;
go($f,$e)})->pack(-anchor=>'nw',-side=>'left');
$down2=$fm_set->Label(-text=>"        ")->pack(-anchor=>'nw',-side=>'left');
$down2=$fm_set->Button(-text=>"Download File",-command=>\&downloadh)->pack(-anchor=>'nw',-side=>'left');
}
sub go
{
@fpdb=();
$pfile="";
$helsingle="";
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my($start,$end)=@_;
open(CO,$m);
$oph="";
while(<CO>)
{
if($_=~/^ATOM/)
{
$ch=substr($_,23,3);
if($ch<=$end && $ch>=$start)
{
$oph.=$_;
}
}
}
close CO;
$txt->delete('1.0','end');
$txt->insert('1.0',$oph);
$pfile=$txt->get('1.0','end');
@fpdb=split(/\n/,$pfile);
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
for(my $i=0;$i<scalar(@chains);$i++)
{
$cha=$chains[$i];
@helres=();
@helfinal=();
$helsingle.=">CHAIN-$cha|$start-$end residues:\n";
for(my $j=0;$j<scalar(@fpdb);$j++)
{
$c1=substr($fpdb[$j],21,1);
if($cha eq $c1)
{
push(@helres,substr($fpdb[$j],17,3));
}
}
helixres(@helres);
}	
}
sub helixres
{
@helix=();
@helfinal=();
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my(@helix)=@_;
for($i=0;$i<scalar(@helix);$i++)
{
for($j=$i+1;$j<scalar(@helix);$j++)
{
if($helix[$i] eq $helix[$j])
{
next;
}
else
{
push(@helfinal,$helix[$i]);
$i=$j;
last;
}
}
}
push(@helfinal,$helix[$#helix]);
for($i=0;$i<scalar(@helfinal);$i++)
{
$helsingle.=$amino{$helfinal[$i]};
}
$helsingle.="\n\n";
$txt1->delete('1.0','end');
$txt1->insert('1.0',$helsingle);
}
sub selector
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$line="";
$fire="";
open(CH,$m);
while(<CH>)
{
if($_=~/^ATOM/)
{
$fire.=$_;
}
}
close CH;
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',$fire);
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
$s2="";
$p2="";
$c2="";
for($i=0;$i<scalar(@chains);$i++)
{
$s2=$fm_set->Radiobutton(-text=>$chains[$i],-value=>"$chains[$i]",-variable=>\$p2,-command=>sub {$c2=$p2; sadhana($c2)},-font=>[-size =>'10'])->pack(-side=>'left');  
}  
$s2=$fm_set->Radiobutton(-text=>"Non std. Residues",-value=>"nres",-variable=>\$p2,-command=>sub {$c2=$p2; sadhana($c2)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
sub sadhana
{
my($a)=@_;
if($a eq "nres")
{
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
open(RESS,$m);
@non=();
@dd=();
while(<RESS>)
{
if($_=~/^HETNAM/)
{
push(@non,substr($_,11,3));
}
}
for($i=0;$i<=scalar(@non);$i++)
{
for($j=$i+1;$j<=scalar(@non);$j++)
{
if($non[$i] eq $non[$j])
{
next;
}
else
{
push(@dd,$non[$i]);
$i=$j;
last;
}
}
}
push(@dd,$non[$#non]);
push(@dd,"HOH");
my $dropdown = $fm_gr1->BrowseEntry(-label => "                                                				                            Select your Amino Acid",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
foreach (@dd) 
{
$dropdown->insert('end', $_);
}
$but=$fm_gr1->Button(-text=>"Go",-command=>sub{$ma=$dropdown_value;remo1($ma)})->pack(-anchor=>'nw',-side=>'left');
$down=$fm_gr1->Button(-text=>"Download File",-command=>\&downloadnres)->pack(-side=>"right");

sub remo1
{
my($re)=@_;
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
open(REMO1,$m);
$d="";
while(<REMO1>)
{
if($_=~/^HETATM/)
{
if(substr($_,17,3) eq $re)
{
$d.=$_;
}
}
}
close REMO1;
$txt->insert('1.0',"$d");
}
}
else
{
open(SS,$m);
$ss="";
while(<SS>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $a)
{
$ss.=$_;
}
}
}
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',$ss);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
$s1="";
$p1="";
$c1="";
$s1=$fm_gr->Radiobutton(-text=>"CA",-value=>"CA",-variable=>\$p1,-command=>sub {$c1=$p1; sad($c1,$a)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_gr->Radiobutton(-text=>"Side chain",-value=>"Backbone",-variable=>\$p1,-command=>sub {$c1=$p1; sad($c1,$a)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_gr->Radiobutton(-text=>"Backbone",-value=>"Side chain",-variable=>\$p1,-command=>sub {$c1=$p1; sad($c1,$a)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_gr->Radiobutton(-text=>"Std. Residue",-value=>"res",-variable=>\$p1,-command=>sub {$c1=$p1; sad($c1,$a)},-font=>[-size =>'10'])->pack(-side=>'left');  
$down=$fm_gr->Button(-text=>"Download File",-command=>\&selectdownload)->pack(-side=>"right");
}
}
sub sad
{
my($a,$b)=@_;
if($a eq "res")
{
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
open(SWIH,$m);
@gchh1=();
@resh1=();
@finalh1=();
while(<SWIH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $b)
{
push(@finalh1,substr($_,17,3));
push(@resh1,substr($_,23,3));
}
}
}
close SWIH;
for($i=0;$i<scalar(@resh1);$i++)
{
for($j=$i+1;$j<scalar(@resh1);$j++)
{
if($resh1[$i] eq $resh1[$j])
{
next;
}
else
{
push(@gchh1,$finalh1[$i]);
$i=$j;
last;
}
}
}
push(@gchh1,$finalh1[$#finalh1]);


my $dropdown = $fm_gr1->BrowseEntry(-label => "                                                				                            Select your Amino Acid",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
foreach (@gchh1) 
{
$dropdown->insert('end', $_);
}
$but=$fm_gr1->Button(-text=>"Go",-command=>sub{$ma=$dropdown_value;remo($ma,$b)})->pack(-anchor=>'nw',-side=>'left');
sub remo
{
my($re,$cha)=@_;
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
open(REMO1,$m);
$d="";
while(<REMO1>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $cha)
{
if(substr($_,17,3) eq $re)
{
$d.=$_;
}
}
}
}
close REMO1;
$txt->insert('1.0',"$d");
}
}
elsif($a eq "CA")
{
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
open(SS1,$m);
$d="";
while(<SS1>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $b)
{
if(substr($_,13,4) eq "CA  ")
{
$d.=$_;
}
}
}
}
close SS1;
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',$d);
}
elsif($a eq "Backbone")
{
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
open(SS2,$m);
$d="";
while(<SS2>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $b)
{
if((substr($_,13,4) eq "CA  ") || (substr($_,13,4) eq "N   ") || (substr($_,13,4) eq "C   ") || (substr($_,13,4) eq "O   "))
{
}
else
{
$d.=$_;
}
}
}
}
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',$d);
close SS2;
}
elsif($a eq "Side chain")
{
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
open(SS3,$m);
$d="";
$d="";
while(<SS3>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $b)
{
if((substr($_,13,4) eq "CA  ") || (substr($_,13,4) eq "N   ") || (substr($_,13,4) eq "C   ") || (substr($_,13,4) eq "O   "))
{
$d.=$_;
}
}
}
}
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',$d);
close SS3;
}
}
##################################################
#####     PDB format -> Fasta converter      #####
##################################################
sub fast
{
open(FGH,$m);
@ch=();
@chainsh=();
while(<FGH>)
{
if($_=~/^HEADER/)
{
$m1=substr($_,62,4);
}
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@ch=split(/,/,$_);
push(@chainsh,@ch);
}
}
}
close FGH;
$k=0;
@baby=();
@dollar=();
open(DOL,$m);
while(<DOL>)
{
if($_=~/^ATOM/)
{
push(@baby,substr($_,21,1));
}
}
for($i=0;$i<scalar(@baby);$i++)
{
for($j=$i+1;$j<scalar(@baby);$j++)
{
if($baby[$i] eq $baby[$j])
{
next;
}
else
{
$dollar[$k].=$baby[$i];
$i=$j;
$k++;
last;
}
}
}
$dollar[$k].=$baby[$#baby];
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
@final1=();
for($ch=0;$ch<scalar(@dollar);$ch++)
{
open(SAI,$m);
$single="";
@gch1=();
@res1=();
@finish1=();
@atomres1=();
@atomress1=();
@finalatomres1=();
@finalatomress1=();
$rescount="";
$single.="\n","\n";
$single.=">CHAIN $a residues\n";
while(<SAI>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $dollar[$ch])
{
push(@res1,substr($_,17,3));
push(@atomres1,substr($_,23,3));
push(@atomress1,substr($_,23,3));
}
}
}
close SAI;
for($i=0;$i<scalar(@atomres1);$i++)
{
for($j=$i+1;$j<scalar(@atomres1);$j++)
{
if($atomres1[$i] eq $atomres1[$j])
{
next;
}
else
{
$final1[$ch].=$amino{$res1[$i]};
$i=$j;
last;
}
}
}
$final1[$ch].=$amino{$res1[$#res1]};
}
@fasta=();
$fasta[0].="The FASTA sequence of the PDB id $m1 is:\n\n\n";
for($i=0;$i<scalar(@chainsh);$i++)
{
$fasta[$i].=">$m1:$dollar[$i]|PDBID|CHAIN|SEQUENCE";
}
for($i=0;$i<scalar(@final1);$i++)
{
$fasta[$i].="\n";
for($j=0;$j<length($final1[$i]);$j++)
{
if($j == 79)
{
$fasta[$i].="\n";
}
else
{
chomp($final1[$i]);
$fasta[$i].=substr($final1[$i],$j,1);
}
}
$fasta[$i].="\n";
}
$txt1->delete('1.0','end');
$txt1->insert("$i.0","@fasta");
}
sub gv
{
if($m ne "")
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$txt1->delete('1.0','end');
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
my $bn1_ppp_1 = $fm_look->Button(-relief=>'raised',-text=>"Heat Map",-command=>\&heatmap,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
my $bn1_ppp_2 = $fm_look->Button(-relief=>'raised',-text=>"Hydrophobicity Graph",-command=>\&hydro,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
my $sai = $fm_look->Button(-relief=>'raised',-text=>"Dot Plot",-command=>\&dotplot,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
my $sai1 = $fm_look->Button(-relief=>'raised',-text=>"Mobility Graph",-command=>\&tempg,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
my $sai2 = $fm_look->Button(-relief=>'raised',-text=>"Property Graph",-command=>\&chains,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$bn1_ppp_1->pack(-side=>'left',-expand=>1,-fill=>'x');
$bn1_ppp_2->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai1->pack(-side=>'left',-expand=>1,-fill=>'x');
$sai2->pack(-side=>'left',-expand=>1,-fill=>'x');
open(FH,$m);
$op="";
$m1="";
while(<FH>)
{
if($_=~/^HEADER/)
{
$m1=substr($_,62,4);
}
$op.=$_.$linst;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
##################################################
#####               HEAT MAP                 #####
#####    Helps in finding the CA-CA distance #####
#####    Secondary structure graphically     #####
##################################################
sub heatmap
{
$mw2=MainWindow->new(-title=>'Heat Map key',-height => 600, -width => 600);
$mw1=MainWindow->new(-title=>'Heat Map');
$frame1a=$mw2->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1a->pack(-side=>'top',-expand=>0,-fill=>'x');
$l1=$frame1a->Label(-text=>">=0  and  <=6",-font=>[-size=>"10"],-foreground=>"#990000")->pack(-side=>'top');
$l2=$frame1a->Label(-text=>">=7  and  <=12",-font=>[-size=>"10"],-foreground=>"red")->pack(-side=>'top');
$l3=$frame1a->Label(-text=>">=13  and  <=18",-font=>[-size=>"10"],-foreground=>"#FF6666")->pack(-side=>'top');
$l4=$frame1a->Label(-text=>">=19  and  <=24",-font=>[-size=>"10"],-foreground=>"#FF9999")->pack(-side=>'top');
$l5=$frame1a->Label(-text=>">=25  and  <=30",-font=>[-size=>"10"],-foreground=>"#005C99")->pack(-side=>'top');
$l6=$frame1a->Label(-text=>">=31  and  <=36",-font=>[-size=>"10"],-foreground=>"#0099FF")->pack(-side=>'top');
$l7=$frame1a->Label(-text=>">=36  and  <=42",-font=>[-size=>"10"],-foreground=>"#66C2FF")->pack(-side=>'top');
$l8=$frame1a->Label(-text=>">=43  and  <=50",-font=>[-size=>"10"],-foreground=>"#B2E0FF")->pack(-side=>'top');
$mw1->geometry(($mw1->maxsize())[0] .'x'.($mw1->maxsize())[1]);
$frame1=$mw1->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1->pack(-side=>'top',-expand=>0,-fill=>'x');
$frame3=$mw1->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1);
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
$s="";
$h="";
$hc="";
for($i=0;$i<scalar(@chains);$i++)
{
$s=$frame1->Radiobutton(-text=>$chains[$i],-value=>"$chains[$i]",-variable=>\$h,-command=>sub {$hc=$h; chupa($hc)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
MainLoop;
sub chupa
{
$frame3->destroy();
$frame3=$mw1->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1);
my $c=$frame3->Canvas(-width => 1400, -height => 700); 
$c->pack; 
$c->createLine(50,600,1380,600);  
$c->createLine(50,25,50,600); 
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my($a)=@_;
$c->createText(700,640,-fill => 'black', -text =>"Scale:  X-Axis-> Chain:$a;    Y-Axis-> Chain:$a",-font=>[-size =>'15',-weight =>'bold',]); 
open(SWI,$m);
@gch=();
@x=();
@y=();
@z=();
@final=();
while(<SWI>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
if(substr($_,21,1) eq $a)
{
push(@final,substr($_,17,3));
push(@x,substr($_,31,7));
push(@y,substr($_,39,7));
push(@z,substr($_,47,7));
}
}
}
}
for($i=0;$i<scalar(@final);$i++)
{
push(@gch,$amino{$final[$i]});;
}
$res_width="";
$rescount=scalar(@gch);
$width=1340-50;
$res_width=$width/$rescount;
$j=0;
for($i=0;$i<scalar(@gch);$i++)
{
if($i == $j*10)
{
$c->createText(50+$res_width*($i+1),605,-fill =>'black',-text =>"$i");
$j++;
}
}
$wres_width="";
$wrescount=scalar(@gch);
$wwidth=630-50;
$wres_width=$wwidth/$wrescount;
$j=0;
for($i=0;$i<scalar(@gch);$i++)
{
if($i == $j*10)
{
$c->createText(40,600-$wres_width*($i+1),-fill =>'black',-text =>"$i");
$j++;
}
}
for($i=0;$i<scalar(@x);$i++)
{
for($j=0;$j<scalar(@x);$j++)
{
$xans="";
$yans="";
$zans="";
$ans="";
$xans=($x[$j]-$x[$i])*($x[$j]-$x[$i]);
$yans=($y[$j]-$y[$i])*($y[$j]-$y[$i]);
$zans=($z[$j]-$z[$i])*($z[$j]-$z[$i]);
$ans=sqrt($xans+$yans+$zans);
if($ans >= 0 && $ans <= 6)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#990000');
}
elsif($ans >= 7 && $ans <= 12)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => 'red');
}
elsif($ans >= 13 && $ans <= 18)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#FF6666');
}
elsif($ans >= 19 && $ans <= 24)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#FF9999');
}
elsif($ans >= 25 && $ans <= 30)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#005C99');
}
elsif($ans >= 31 && $ans <= 36)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#0099FF');
}
elsif($ans >= 36 && $ans <= 42)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#66C2FF');
}
elsif($ans >= 43 && $ans <= 50)
{
$c->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),56+$res_width*($i+1),594-$wres_width*($j+1),-fill => '#B2E0FF');
}
}
}
}
}
sub hydro
{
$mwh=MainWindow->new(-title=>'Hydrophobicity Graph');
$mwh->geometry(($mwh->maxsize())[0] .'x'.($mwh->maxsize())[1]);
$frame1h=$mwh->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1h->pack(-side=>'top',-expand=>0,-fill=>'x');
$frame3h=$mwh->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3h->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1h);
open(FGH,$m);
@ch=();
@chainsh=();
while(<FGH>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@ch=split(/,/,$_);
push(@chainsh,@ch);
}
}
}
close FGH;
$sh="";
$hh="";
$hch="";
for($i=0;$i<scalar(@chainsh);$i++)
{
$sh=$frame1h->Radiobutton(-text=>$chainsh[$i],-value=>"$chainsh[$i]",-variable=>\$hh,-command=>sub {$hch=$hh; dumbo($hch)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
}
sub dumbo
{
$frame3h->destroy();
$frame3h=$mwh->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3h->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1h);
my $ch=$frame3h->Canvas(-width => 1400, -height => 700); 
$ch->pack; 
$ch->createLine(50,300,1340,300);    
$ch->createLine(50,25,50,600); 

%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my($ah)=@_;
$ch->createText(700,640,-fill => 'black', -text =>"Scale:  X-Axis-> Chain:$ah;    Y-Axis-> Chain:Hydrphobic Values",-font=>[-size =>'15',-weight =>'bold',]); 
open(SWIH,$m);
@gchh=();
@resh=();
@finalh=();
while(<SWIH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ah)
{
push(@finalh,substr($_,17,3));
push(@resh,substr($_,23,3));
}
}
}
close SWIH;
for($i=0;$i<scalar(@resh);$i++)
{
for($j=$i+1;$j<scalar(@resh);$j++)
{
if($resh[$i] eq $resh[$j])
{
next;
}
else
{
push(@gchh,$amino{$finalh[$i]});
$i=$j;
last;
}
}
}
push(@gchh,$amino{$finalh[$#finalh]});
$res_width="";
$rescount=scalar(@gchh);
$width=1330-50;
$res_width=$width/$rescount;
$j=0;
for($i=0;$i<scalar(@gchh);$i++)
{
$ch->createText(50+$res_width*($i+1),305,-fill =>'red',-text =>"$gchh[$i]");
}
%hydro=('A'=>'1.8','R'=>'-4.5','N'=>'-3.5','D'=>'-3.5','C'=>'2.5','E'=>'-3.5','Q'=>'-3.5',
		'G'=>'-0.4','H'=>'-3.2',=>'I'=>'4.5','L'=>'3.8','K'=>'-3.9','M'=>'1.9','F'=>'2.8',
		'P'=>'-1.6','S'=>'-0.8','T'=>'-0.7','W'=>'-0.9','Y'=>'-1.3','V'=>'4.2');
$res_widthh="";
$rescounth=6;
$widthh=262.5-35;
$res_widthh=$widthh/$rescounth;
for($i=1;$i<=6;$i++)
{
$ch->createText(45,300-$res_widthh*($i),-fill =>'red',-text =>"$i");
$ch->createText(40,300+$res_widthh*($i),-fill =>'red',-text =>"-$i");
}
for($i=0;$i<scalar(@gchh);$i++)
{
if($hydro{$gchh[$i]} <0 && $hydro{$gchh[$i+1]} <0)
{
$ch->createLine(50+$res_width*($i+1),300+$res_widthh*(-($hydro{$gchh[$i]})),50+$res_width*($i+2),300+$res_widthh*(-($hydro{$gchh[$i+1]})));
}
elsif($hydro{$gchh[$i]} >0 && $hydro{$gchh[$i+1]} >0)
{
$ch->createLine(50+$res_width*($i+1),300-$res_widthh*($hydro{$gchh[$i]}),50+$res_width*($i+2),300-$res_widthh*($hydro{$gchh[$i+1]}));
}
elsif($hydro{$gchh[$i]} <0 && $hydro{$gchh[$i+1]} >0)
{
$ch->createLine(50+$res_width*($i+1),300+$res_widthh*(-($hydro{$gchh[$i]})),50+$res_width*($i+2),300-$res_widthh*($hydro{$gchh[$i+1]}));
}
elsif($hydro{$gchh[$i]} >0 && $hydro{$gchh[$i+1]} <0)
{
$ch->createLine(50+$res_width*($i+1),300-$res_widthh*($hydro{$gchh[$i]}),50+$res_width*($i+2),300+$res_widthh*(-($hydro{$gchh[$i+1]})));
}
}
}
##################################################
#####               Dot plot                 #####
#####   Used to find the interchain distance #####
##################################################
sub dotplot
{
$mwdot=MainWindow->new(-title=>'Dot Plot');
$mwdot->geometry(($mwdot->maxsize())[0] .'x'.($mwdot->maxsize())[1]);
$frame1dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1dot->pack(-side=>'top',-expand=>0,-fill=>'x');
$frame2dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame2dot->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1dot);
$frame3dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3dot->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame2dot);
open(FGH,$m);
@ch=();
@chainsh=();
while(<FGH>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@ch=split(/,/,$_);
push(@chainsh,@ch);
}
}
}
close FGH;
$hh="";
$sh="";
$hch="";
for($i=0;$i<scalar(@chainsh);$i++)
{
$sh=$frame1dot->Radiobutton(-text=>$chainsh[$i],-value=>"$chainsh[$i]",-variable=>\$hh,-command=>sub {$hch=$hh; dot($hch)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
MainLoop;
sub dot
{
$frame2dot->destroy();
$frame2dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame2dot->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1dot);
$frame3dot->destroy();
$frame3dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3dot->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame2dot);
my($one)=@_;
open(FGH,$m);
@ch=();
@chainsh=();
while(<FGH>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@ch=split(/,/,$_);
push(@chainsh,@ch);
}
}
}
close FGH;
$hh1="";
$sh="";
$hch1="";
for($i=0;$i<scalar(@chainsh);$i++)
{
$sh=$frame2dot->Radiobutton(-text=>$chainsh[$i],-value=>"$chainsh[$i]",-variable=>\$hh1,-command=>sub {$hch1=$hh1; pep($one,$hch1)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
}
sub pep
{
@gch=();
my($a,$b)=@_;
$frame3dot->destroy();
$frame3dot=$mwdot->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3dot->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame2dot);
my $cdot=$frame3dot->Canvas(-width => 1400, -height => 700); 
$cdot->pack; 
$cdot->createLine(50,600,1380,600);  
$cdot->createLine(50,25,50,600); 
$cdot->createText(700,620,-fill => 'black', -text =>"Scale:  X-Axis-> Chain:$b;    Y-Axis-> Chain:$a",-font=>[-size =>'9',-weight =>'bold',]); 
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
open(DO,$m);
@chain1=();
while(<DO>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
if(substr($_,21,1) eq $a)
{
push(@chain1,substr($_,17,3));
}
}
}
}
close DO;
open(DO1,$m);
@chain2=();
while(<DO1>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
if(substr($_,21,1) eq $b)
{
push(@chain2,substr($_,17,3));
}
}
}
}
close DO1;

for($i=0;$i<=scalar(@chain1);$i++)
{
push(@gch,$amino{$chain1[$i]});;
}
$res_width="";
$rescount=scalar(@gch);
$width=1340-50;
$res_width=$width/$rescount;
$j=0;
for($i=0;$i<scalar(@gch);$i++)
{
if($i == $j*10)
{
$cdot->createText(50+$res_width*($i+1),605,-fill =>'black',-text =>"$i");
$j++;
}
}
$wres_width="";
$wrescount=scalar(@gch);
$wwidth=630-50;
$wres_width=$wwidth/$wrescount;
$j=0;
for($i=0;$i<scalar(@gch);$i++)
{
if($i == $j*10)
{
$cdot->createText(40,600-$wres_width*($i+1),-fill =>'black',-text =>"$i");
$j++;
}
}
for($i=0;$i<scalar(@chain1);$i++)
{
for($j=0;$j<scalar(@chain2);$j++)
{
if($chain1[$i] eq $chain2[$j])
{
$cdot->createRectangle(50+$res_width*($i+1),600-$wres_width*($j+1),53+$res_width*($i+1),597-$wres_width*($j+1),-fill =>"black");
}
}
}
}
}
##################################################
#####               Temprature Graph         #####
#####   Based upon the mobility and bfactor  #####
##################################################
sub tempg
{
$mw_pp = MainWindow->new(-title=>'Temprature Graph');
$mw_pp->geometry(($mw_pp->maxsize())[0] .'x'.($mw_pp->maxsize())[1]);
$frame1h=$mw_pp->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3h=$mw_pp->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1h->destroy();
$frame3h->destroy();
$frame1h=$mw_pp->Frame(-relief=>'sunken',-borderwidth=>5);
$frame1h->pack(-side=>'top',-expand=>0,-fill=>'x');
$frame3h=$mw_pp->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3h->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1h);
open(FGH,$m);
@ch=();
@chainsh=();
while(<FGH>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@ch=split(/,/,$_);
push(@chainsh,@ch);
}
}
}
close FGH;
$sh="";
$hh="";
$hch="";
for($i=0;$i<scalar(@chainsh);$i++)
{
$sh=$frame1h->Radiobutton(-text=>$chainsh[$i],-value=>"$chainsh[$i]",-variable=>\$hh,-command=>sub {$hch=$hh; dumbod($hch)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
sub dumbod
{
$frame3h->destroy();
$frame3h=$mw_pp->Frame(-relief=>'sunken',-borderwidth=>5);
$frame3h->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$frame1h);
my $ch=$frame3h->Canvas(-width => 1400, -height => 700); 
$ch->pack; 
$ch->createLine(30,600,1400,600);    
$ch->createLine(30,25,30,600);
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
my($ah)=@_;
$ch->createText(700,640,-fill => 'black', -text =>"Scale:  X-Axis-> Chain:$ah;    Y-Axis-> Chain:B-factor",-font=>[-size =>'15',-weight =>'bold',]); 
open(SWIH,$m);
@gchh=();
@resh=();
@finalh=();
while(<SWIH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ah)
{
push(@finalh,substr($_,17,3));
push(@resh,substr($_,23,3));
}
}
}
close SWIH;
for($i=0;$i<scalar(@resh);$i++)
{
for($j=$i+1;$j<scalar(@resh);$j++)
{
if($resh[$i] eq $resh[$j])
{
next;
}
else
{
push(@gchh,$amino{$finalh[$i]});
$i=$j;
last;
}
}
}
push(@gchh,$amino{$finalh[$#finalh]});
$res_width="";
$rescount=scalar(@gchh);
$width=1350-30;
$res_width=$width/$rescount;
$j=0;
open(MOM,$m);
@bfactor=();
while(<MOM>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ah)
{
push(@bfactor,substr($_,61,5));
}
}
}
close MOM;
$bfac=0;
$k=0;
@bfactans=();
@reee=();
for($i=0;$i<scalar(@resh);$i++)
{
for($j=$i+1;$j<scalar(@resh);$j++)
{
if($resh[$i] eq $resh[$j])
{
$bfac=$bfac+$bfactor[$j];
$k++;
next;
}
else
{
push(@gchh,$amino{$finalh[$i]});
$bfac=$bfac/$k;
push(@bfactans,$bfac);
push(@reee,$resh[$i]);
$i=$j;
$k=0;
$bfac=0;
last;
}
}
}
$max=$bfactans[0];
$mm="";
$ff="";
for($i=0;$i<scalar(@bfactans);$i++)
{
if($max < $bfactans[$i])
{
$max=$bfactans[$i];
$mm=$gchh[$i];
$ff=$reee[$i];
}
}
$ch->createText(650,30,-fill =>'blue',-text =>"The residue $mm having residue number $ff in chain $ah is having the highest mobility of $max");
for($i=0;$i<scalar(@gchh);$i++)
{
$ch->createText(30+$res_width*($i+1),605,-fill =>'red',-text =>"$gchh[$i]");
}
%hydro=('A'=>'1.8','R'=>'-4.5','N'=>'-3.5','D'=>'-3.5','C'=>'2.5','E'=>'-3.5','Q'=>'-3.5','G'=>'-0.4','H'=>'-3.2',=>'I'=>'4.5','L'=>'3.8','K'=>'-3.9','M'=>'1.9',
'F'=>'2.8','P'=>'-1.6','S'=>'-0.8','T'=>'-0.7','W'=>'-0.9','Y'=>'-1.3','V'=>'4.2');
$res_widthh="";
$rescounth=100;
$widthh=600-25;
$res_widthh=$widthh/$rescounth;
$j=0;
for($i=0;$i<=100;$i++)
{
if($i == $j*10)
{
$ch->createText(20,600-$res_widthh*($i),-fill =>'red',-text =>"$i");
$j++;
}
}
for($i=0;$i<scalar(@gchh);$i++)
{
$ch->createLine(30+$res_width*($i+1),600-$res_widthh*($bfactans[$i]),30+$res_width*($i+2),600-$res_widthh*($bfactans[$i+1]));
}
}
}
##################################################
#####  Chain subroutine (Graphical viewrer)  #####
##################################################
sub chains
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$line="";
$fire="";
open(CH,$m);
while(<CH>)
{
if($_=~/^ATOM/)
{
$fire.=$_;
}
}
close CH;
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',$fire);
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
$s="";
$p="";
$c="";
for($i=0;$i<scalar(@chains);$i++)
{
$s=$fm_set->Radiobutton(-text=>$chains[$i],-value=>"$chains[$i]",-variable=>\$p,-command=>sub {$c=$p; opt($c)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
$down=$fm_set->Button(-text=>"Download File",-command=>\&download)->pack(-side=>"right");
}
##################################################
#####    Graphical veiwer subroutine         #####
##################################################
sub opt
{
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
my($chain)=@_;
my $dropdown_value;
my $dropdown = $fm_gr1->BrowseEntry(-label => "                                      				                                     From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(DELE,$m);
@fainishs=();
@baegins=();
while(<DELE>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $chain)
{
$start=substr($_,23,3);
push(@baegins,$start);
$end=substr($_,23,3);
push(@fainishs,$end);
}
}
}
close DELE;
@fbegins=();
@ffinishs=();
for($i=0;$i<scalar(@baegins);$i++)
{
for($j=$i+1;$j<scalar(@baegins);$j++)
{
if($baegins[$i] eq $baegins[$j])
{
next;
}
else
{
push(@fbegins,$baegins[$i]);
push(@ffinishs,$fainishs[$i]);
$i=$j;
last;
}
}
}
push(@fbegins,$baegins[$#baegina]);
push(@ffinishs,$fainishs[$#fainishs]);
foreach (@fbegins) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_gr1->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach ( @ffinishs) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_gr1->Button(-text=>"Go",-command=>sub{$fs=$dropdown_value; 
$es=$dropdown_valueq;
chain($chain,$fs,$es)})->pack(-anchor=>'nw',-side=>'left');
}
##################################################
#####    Final subroutine to show the graph  #####
#####		of all the sec structs region    #####
##################################################
sub chain
{
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
my $c=$fm_gr->Canvas(-width => 1400, -height => 500); 
$c->pack; 
$c->createLine(50, 250, 1380, 250);  
$c->createText(25, 265, -fill => 'black', -text =>'Residues:'); 
$c->createLine(50, 25, 50, 250); 
$txt1->delete('1.0','end');
my($a,$from,$to)=@_;
$c->createText(700,10,-fill => 'black', -text =>"Scale:  X-Axis-> Chain:$a;    Y-Axis-> Chain:Chemical Properties",-font=>[-size =>'10',-weight =>'bold',]); 
open(FH,$m);
$txt->delete('1.0','end');
$fire="";
while(<FH>)
{
if($_=~/^ATOM \s{1,}\d{1,}\s{1,}\w{1,}\s{1,}\w{3}\s{1}[$a]/)
{
$fire.=$_;
}
}
close FH;
$txt->insert('1.0',$fire);
open(FG,$m);
$txt1->delete('1.0','end');
$cilla="";
$cilla.="Three Letter Amino Acid code for $a is"."\n-------------------------------------------------------------\n";
while(<FG>)
{
if($_=~/^SEQRES \s{1,}\d{1,}\s{1,}[$a]/)
{
$_=~s/SEQRES\s{1,}\d{1,}//;
$_=~s/\d{1,}//;
$_=~s/\s{1,}//;
$_=~s/^[A-Z]//g;
$cilla.=$_;
}
}
close FG;
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
$single="";
@gch1=();
@res1=();
@finish1=();
@atomres1=();
@atomress1=();
@final1=();
@finalatomres1=();
@finalatomress1=();
$rescount="";
$single.="\n","\n";
$single.=">CHAIN $a residues\n";
open(SAI,$m);
while(<SAI>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $a)
{
push(@res1,substr($_,17,3));
push(@atomres1,substr($_,23,3));
push(@atomress1,substr($_,23,3));
}
}
}
close SAI;
for($i=0;$i<scalar(@atomres1);$i++)
{
for($j=$i+1;$j<scalar(@atomres1);$j++)
{
if($atomres1[$i] eq $atomres1[$j])
{
next;
}
else
{
push(@final1,$res1[$i]);
$i=$j;
last;
}
}
}
push(@final1,$res1[$#res1]);
for($i=0;$i<scalar(@atomres1);$i++)
{
for($j=$i+1;$j<scalar(@atomres1);$j++)
{
if($atomres1[$i] eq $atomres1[$j])
{
next;
}
else
{
push(@finalatomres1,$atomres1[$i]);
push(@finalatomress1,$atomress1[$i]);
$i=$j;
last;
}
}
}
push(@finalatomres1,$atomres1[$#atomres1]);
push(@finalatomress1,$atomress1[$#atomress1]);
for($i=0;$i<scalar(@final1);$i++)
{
$single.=$amino{$final1[$i]};
}
$txt1->delete('1.0','end');
$txt1->insert('1.0',$single);
$txt1->insert('1.0',$cilla);
open(SWI,$m);
@gch=();
@res=();
@finish=();
@atomres=();
@atomress=();
@final=();
@finalatomres=();
@finalatomress=();
while(<SWI>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $a)
{
if(substr($_,23,3) >= $from && substr($_,23,3) <= $to)
{
push(@res,substr($_,17,3));
push(@atomres,substr($_,23,3));
push(@atomress,substr($_,23,3));
}
}
}
}
close SWI;
for($i=0;$i<scalar(@atomres);$i++)
{
for($j=$i+1;$j<scalar(@atomres);$j++)
{
if($atomres[$i] eq $atomres[$j])
{
next;
}
else
{
push(@final,$res[$i]);
$i=$j;
last;
}
}
}
push(@final,$res[$#res]);
for($i=0;$i<scalar(@atomres);$i++)
{
for($j=$i+1;$j<scalar(@atomres);$j++)
{
if($atomres[$i] eq $atomres[$j])
{
next;
}
else
{
push(@finalatomres,$atomres[$i]);
push(@finalatomress,$atomress[$i]);
$i=$j;
last;
}
}
}
push(@finalatomres,$atomres[$#atomres]);
push(@finalatomress,$atomress[$#atomress]);
for($i=0;$i<scalar(@final);$i++)
{
push(@gch,$amino{$final[$i]});;
}
$res_width="";
$rescount=scalar(@gch);
$width=1300-50;
$res_width=$width/$rescount;
for($i=0;$i<scalar(@gch);$i++)
{
$c->createText( 50+$res_width*($i+1), 265,-fill => 'black', -text => "$finalatomres[$i]:$gch[$i]");
}
open(FA,$m);
@finishw=();
@beginw=();
while(<FA>)
{
if($_=~/^HELIX/)
{
if(substr($_,19,1) eq $a)
{
$start=substr($_,22,3);
push(@beginw,$start);
$end=substr($_,34,3);
push(@finishw,$end);
}
}
}
close FA;
@graph=();
for($i=0;$i<scalar(@beginw);$i++)
{
for($j=0;$j<scalar(@finalatomres);$j++)
{
if($finalatomres[$j] >= $beginw[$i] && $finalatomres[$j] <= $finishw[$i])
{
push(@graph,$finalatomres[$j]);
}
}
}
@graphf=();
for($i=0;$i<scalar(@finalatomres);$i++)
{
push(@graphf,"n");
}
$i=$from;
$l=0;
while($i <= $to)
{
for($j=0;$j<scalar(@graph);$j++)
{
if($i == $graph[$j])
{
$graphf[$l]="h";
}
}
$i++;
$l++;
}
%desc=('A'=>'ali','R'=>'ba','N'=>'am','D'=>'as','C'=>'su','E'=>'as','Q'=>'am','G'=>'ali','H'=>'ba',=>'I'=>'ali','L'=>'ali','K'=>'ba','M'=>'su',
'F'=>'aro','P'=>'ali','S'=>'hy','T'=>'hy','W'=>'aro','Y'=>'aro','V'=>'ali');
%ass=("I"=>["hy","ali"],"L"=>["hy","ali"],"V"=>["hy","sm","ali"],"C"=>["hy","sm"],
"A"=>["hy","sm","ti"],"G"=>["hy","sm","ti"],"M"=>["hy"],"F"=>["hy","aro"],"Y"=>["hy","po","aro"],"W"=>["hy","po","aro"],"H"=>["hy","po","aro"],
"K"=>["hy","po","pos","ch"],"R"=>["po","pos","ch"],"E"=>["po","ne","ch"],"Q"=>["po"],"D"=>["po","sm","ne","ch"],"N"=>["po","sm"],"S"=>["po","sm","ti"],
"T"=>["hy","po","sm"],"P"=>["sm","pro"],"B"=>["po"],"Z"=>["po"],"X"=>["hy","po","sm","pro","ti","ali","aro","pos","ne","ch"]);
$c->createText(25, 40,-fill => 'black', -text =>'Hydro');
$c->createText(25, 55,-fill => 'black', -text =>'Polar');
$c->createText(25, 70,-fill => 'black', -text =>'Small');
$c->createText(25, 85,-fill => 'black', -text =>'Proli');
$c->createText(25,100,-fill => 'black', -text =>'Tiny');
$c->createText(25,115,-fill => 'black', -text =>'Aliph');
$c->createText(25,130,-fill => 'black', -text =>'Aroma');
$c->createText(25,145,-fill => 'black', -text =>'Posit');
$c->createText(25,160,-fill => 'black', -text =>'Negit');
$c->createText(25,175,-fill => 'black', -text =>'Charg');
$i=0;
foreach $k(@gch)
{
foreach  $q(keys %ass)
{
if($k eq $q)
{
foreach $z(@{$ass{$q}})
{
if($z eq "hy")
{
$c->createRectangle(50+$res_width*($i+1),41,54+$res_width*($i+1),38,-fill => 'red');
}
elsif($z eq "po")
{
$c->createRectangle(50+$res_width*($i+1),56,54+$res_width*($i+1),53,-fill => 'red');
}
elsif($z eq "sm")
{
$c->createRectangle(50+$res_width*($i+1),71,54+$res_width*($i+1),68,-fill => 'red');
}
elsif($z eq "pro")
{
$c->createRectangle(50+$res_width*($i+1),86,54+$res_width*($i+1),83,-fill => 'red');
}
elsif($z eq "ti")
{
$c->createRectangle(50+$res_width*($i+1),101,54+$res_width*($i+1),98,-fill => 'red');
}
elsif($z eq "ali")
{
$c->createRectangle(50+$res_width*($i+1),116,54+$res_width*($i+1),113,-fill => 'red');
}
elsif($z eq "aro")
{
$c->createRectangle(50+$res_width*($i+1),131,54+$res_width*($i+1),128,-fill => 'red');
}
elsif($z eq "pos")
{
$c->createRectangle(50+$res_width*($i+1),146,54+$res_width*($i+1),143,-fill => 'red');
}
elsif($z eq "ne")
{
$c->createRectangle(50+$res_width*($i+1),161,54+$res_width*($i+1),158,-fill => 'red');
}
elsif($z eq "ch")
{
$c->createRectangle(50+$res_width*($i+1),176,54+$res_width*($i+1),173,-fill => 'red');
}
}
}
}
$i++;
}
for($i=0;$i<scalar(@graphf);$i++)
{
if($graphf[$i] eq "h")
{
$c->createRectangle(50+$res_width*($i+1),213,57+$res_width*($i+1),210,-fill => 'yellow');
}
elsif($graphf[$i] eq "n")
{
$c->createRectangle(50+$res_width*($i+1),213,57+$res_width*($i+1),210,-fill => 'black');  
}
}
$c->createText(300,285, -fill => 'red', -text => 'Alpha Helix');
$c->createRectangle(340,289,380,285,-fill => 'yellow');
$c->createText(900,285, -fill => 'red', -text => 'Other Stuff');
$c->createRectangle(940,289,980,285,-fill => 'black');
}
##################################################
#####       SECONDARY STRUCT PREDICTOR       #####
#####    DOne based upon the RMSD value      #####
##################################################
sub stp
{
if($m ne "")
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$txt1->delete('1.0','end');
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
my $ca11 = $fm_look->Button(-relief=>'raised',-text=>"RMSD for conformers",-command=>\&rmsd,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$ca11->pack(-side=>'left',-expand=>1,-fill=>'x');
my $ca12 = $fm_look->Button(-relief=>'raised',-text=>"PSA calculator",-command=>\&psa,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
$ca12->pack(-side=>'left',-expand=>1,-fill=>'x');
my $ca12 = $fm_look->Button(-relief=>'raised',-text=>"Protein - Ligand distance",-command=>\&lpap,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$ca12->pack(-side=>'left',-expand=>1,-fill=>'x');
$l1=$fm_set->Label(-text=>"    ",-font=>[-size =>'10']);
$l2=$fm_set->Button(-text=>"Calculate",-command=>\&psa1);
$l3=$fm_set->Label(-text=>"    ",-font=>[-size =>'10']);
$l4=$fm_set->Entry(-width=>20);
$l5=$fm_set->Label(-text=>"Please enter your grid distance(default value=0.5)      ",-font=>[-size =>'10']);
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any Text file. Please select a Text file *");
}
}
sub rmsd
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$new1=$mw_ppp->getOpenFile();
$new2=$mw_ppp->getOpenFile();
if($new1 ne "" && $new2 ne "")
{
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
my $ca1 = $fm_look->Button(-relief=>'raised',-text=>"RMSD value Calculation",-command=>\&rmsd,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$ca1->pack(-side=>'left',-expand=>1,-fill=>'x');
open(FH,$new1);
$op="";
$m1="";
while(<FH>)
{
if($_=~/^HEADER/)
{
$m1=substr($_,62,4);
}
$op.=$_;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
open(FH,$new2);
$op1="";
$m11="";
while(<FH>)
{
if($_=~/^HEADER/)
{
$m11=substr($_,62,4);
}
$op1.=$_;
}
close FH;
$txt1->delete('1.0','end');
$txt1->insert('1.0',$op1);
open(SAU,$new1);
@c1=();
@c2=();
@f1x=();
@f1y=();
@f1z=();
while(<SAU>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
push(@c1,substr($_,17,3));
push(@c2,substr($_,23,3));
push(@f1x,substr($_,31,7));
push(@f1y,substr($_,39,7));
push(@f1z,substr($_,47,7));
}
}
}
close SAU;
open(SAU1,$new2);
@a1=();
@a2=();
@f2x=();
@f2y=();
@f2z=();
while(<SAU1>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
push(@a1,substr($_,17,3));
push(@a2,substr($_,23,3));
push(@f2x,substr($_,31,7));
push(@f2y,substr($_,39,7));
push(@f2z,substr($_,47,7));
}
}
}
close SAU1;

if(scalar(@c1) > scalar(@a1))
{
$n=scalar(@c1);
}
else
{
$n=scalar(@a1);
}

my $rmsd = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($n,5);
$arrayVar->{"0,0"} = "Residue No.";
$arrayVar->{"0,1"} = "Protein 1";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "Protein 2";
$arrayVar->{"0,4"} = "CA-CA Distance";
$arrayVar->{"0,5"} = "Inference";
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $rm=$rmsd->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols,-rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$rm->rowHeight(0,1); 
$rm->colWidth(20,20,20,20,20,20); 
$rm->colWidth(1=>20,0=>10,2=>10,3=>20,4=>20);
$rm->activate("1,0");
$rm->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$rm->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$ans="";
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#9561
#$angleq[$i]=round($angleq[$i],3);
#$angle[$i-1]=round($angle[$i-1],3);
@inference=();
$total="";
$z=0;
for($i=1;$i<=$n;$i++)
{
$xans="";
$yans="";
$zans="";
$arrayVar->{"$k,0"} = $c2[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $a2[$i-1];
$arrayVar->{"$k,3"} = $a1[$i-1];

$xans=($f2x[$i-1]-$f1x[$i-1])*($f2x[$i-1]-$f1x[$i-1]);
$yans=($f2y[$i-1]-$f1y[$i-1])*($f2y[$i-1]-$f1y[$i-1]);
$zans=($f2z[$i-1]-$f1z[$i-1])*($f2z[$i-1]-$f1z[$i-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
push(@inference,$ans);
$arrayVar->{"$k,4"} = $ans;
$k++;
$z++;
$total=$total+$ans;
}
$total=$total/$z;
my $label = $fm_gr1->Label(-text=>"The RMSD value is $total");
$label->pack();
}
else
{
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',"You have entered invalid number of PDB files. Please select 2 PDB files");
}
}
##################################################
#####  All other possible calculation done   #####
##################################################
sub otc
{
if($m ne "")
{
open(CL,"count.pl");
@c=<CL>;
$hit=$c[0];
close CL;
open(CLS,">count.pl");
$hit++;
print CLS $hit;
close CLS;
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$txt1->delete('1.0','end');
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
$otc2= $fm_look->Button(-relief=>'raised',-text=>"Interactions",-command=>\&interr,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
$otc3= $fm_look->Button(-relief=>'raised',-text=>"Distance Calculation",-command=>\&dss,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$otc4= $fm_look->Button(-relief=>'raised',-text=>"Ligand Distance",-command=>\&ligdis,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
$otc5= $fm_look->Button(-relief=>'raised',-text=>"Region Seperator",-command=>\&sss,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$otc6= $fm_look->Button(-relief=>'raised',-text=>"Center of Mass",-command=>\&centerofmass,-width=>15,-background=>'orange',-activebackground=>'orange',-font=>[-size =>'10']);
$otc7= $fm_look->Button(-relief=>'raised',-text=>"Radius of Gyration",-command=>\&rog,-width=>15,-background=>'#D2691E',-activebackground=>'#D2691E',-font=>[-size =>'10']);
$otc5->pack(-side=>'left',-expand=>1,-fill=>'x');
$otc2->pack(-side=>'left',-expand=>1,-fill=>'x');
$otc3->pack(-side=>'left',-expand=>1,-fill=>'x');
$otc4->pack(-side=>'left',-expand=>1,-fill=>'x');
$otc7->pack(-side=>'left',-expand=>1,-fill=>'x');
$otc6->pack(-side=>'left',-expand=>1,-fill=>'x');
open(FH,$m);
$op="";
$m1="";
while(<FH>)
{
$op.=$_.$linst;
}
close FH;
$txt->delete('1.0','end');
$txt->insert('1.0',$op);
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
##################################################
#####              Interactions              #####
##### Calculate all the necessary interaction#####
##################################################
sub centerofmass
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
open(FGH,$m);
$ans=0;
$ans1=0;
$ans2=0;
$ans3=0;
$ans4=0;
$an=0;
$an1=0;
$an2=0;
$an3=0;
$an4=0;
$answ=0;
$answ1=0;
$answ2=0;
$answ3=0;
$answ4=0;
%mass=("C"=>"12","H"=>"1","O"=>"16","S"=>"17","N"=>"14");
@a=();
@b=();
@c=();
@d=();
@e=();
while(<FGH>)
{
if($_=~/^ATOM/)
{
$ele=substr($_,77,1);
if($ele eq "C")
{
push(@a,$_);
}
if($ele eq "N")
{
push(@b,$_);
}
if($ele eq "O")
{
push(@c,$_);
}
if($ele eq "H")
{
push(@d,$_);
}
if($ele eq "S")
{
push(@e,$_);
}
}
}
$l1=$mass{"N"};
$l=$mass{"C"};
$l2=$mass{"O"};
$l3=$mass{"H"};
$l4=$mass{"S"};
for($i=0;$i<scalar(@a);$i++)
{
$x1=substr($a[$i],31,7);
$y1=substr($a[$i],42,7);
$z1=substr($a[$i],48,7);
$ans+=(($l*$x1)/$l);
$an+=(($l*$y1)/$l);
$answ+=(($l*$z1)/$l);
}
for($i=0;$i<scalar(@b);$i++)
{
$x2=substr($b[$i],31,7);
$y2=substr($b[$i],42,7);
$z2=substr($b[$i],48,7);
$ans1+=(($l1*$x2)/$l1);
$an1+=(($l1*$y2)/$l1);
$answ1+=(($l1*$z1)/$l1);
}
for($i=0;$i<scalar(@c);$i++)
{
$x3=substr($c[$i],31,7);
$y3=substr($c[$i],42,7);
$z3=substr($c[$i],48,7);
$ans2+=(($l2*$x3)/$l2);
$an2+=(($l2*$y3)/$l2);
$answ2+=(($l2*$z3)/$l2);
}
for($i=0;$i<scalar(@d);$i++)
{
$x4=substr($d[$i],31,7);
$y4=substr($d[$i],42,7);
$z3=substr($d[$i],48,7);
$ans3+=(($l3*$x4)/$l3);
$an3+=(($l3*$y4)/$l3);
$answ3+=(($l3*$z4)/$l3);
}
for($i=0;$i<scalar(@e);$i++)
{
$x5=substr($e[$i],31,7);
$y5=substr($e[$i],42,7);
$z5=substr($e[$i],48,7);
$ans4+=(($l4*$x5)/$l4);
$an4+=(($l4*$y5)/$l4);
$answ4+=(($l4*$z5)/$l4);
}
$ans=round($ans,3);
$ans1=round($ans1,3);
$ans2=round($ans2,3);
$ans3=round($ans3,3);
$ans4=round($ans4,3);
$an=round($an,3);
$an1=round($an1,3);
$an2=round($an2,3);
$an3=round($an3,3);
$an4=round($an4,3);
$answ=round($answ,3);
$answ1=round($answ1,3);
$answ2=round($answ2,3);
$answ3=round($answ3,3);
$answ4=round($answ4,3);
$ouuu="";
$ouuu.= "CALCULATION OF CENTER OF MASS OF ATOM's W.R.T X, Y, Z CO-ORDINATES: \n\n" ;
$ouuu.= "Center of mass of C atom wrt X co: " ;
$ouuu.= "$ans\n";
$ouuu.= "Center of mass of N atom wrt X co: " ;
$ouuu.= "$ans1\n";
$ouuu.= "Center of mass of O atom wrt X co: " ;
$ouuu.= "$ans2\n";
$ouuu.= "Center of mass of H atom wrt X co: " ;
$ouuu.= "$ans3\n";
$ouuu.= "Center of mass of S atom wrt X co: " ;
$ouuu.= "$ans4\n\n";
$ouuu.= "Center of mass of C atom wrt Y co: " ;
$ouuu.= "$an\n";
$ouuu.= "Center of mass of N atom wrt Y co: " ;
$ouuu.= "$an1\n";
$ouuu.= "Center of mass of O atom wrt Y co: " ;
$ouuu.= "$an2\n";
$ouuu.= "Center of mass of H atom wrt Y co: " ;
$ouuu.= "$an3\n";
$ouuu.= "Center of mass of S atom wrt Y co: " ;
$ouuu.= "$an4\n\n";
$ouuu.= "Center of mass of C atom wrt Z co: " ;
$ouuu.= "$answ\n";
$ouuu.= "Center of mass of N atom wrt Z co: " ;
$ouuu.= "$answ1\n";
$ouuu.= "Center of mass of O atom wrt Z co: " ;
$ouuu.= "$answ2\n";
$ouuu.= "Center of mass of H atom wrt Z co: " ;
$ouuu.= "$answ3\n";
$ouuu.= "Center of mass of S atom wrt Z co: " ;
$ouuu.= "$answ4\n";
$txt1->delete('1.0','end');
$txt1->insert("1.0","$ouuu");
close FGH;
}
sub rog
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
open(FGH,$m);
@aa=();
while(<FGH>)
{
if($_=~/^ATOM/)
{
$cc=substr($_,17,3);
push(@aa,$cc);
}
}
@aa1 = do{ my %seen; grep { !$seen{$_}++ } @aa };
$element=scalar(@aa1);
$uiii="";
$uiii.="The number of unique amino acids in the given PDB file = ";
$uiii.="$element\n\n";
$cal1=($element^0.34);
$rg=2.83* $cal1;
$rg=round($rg,3);
$uiii.="The Radius of Gyration of the given PDB file =";
$uiii.="$rg";
$txt1->delete('1.0','end');
$txt1->insert("1.0","$uiii");
close FGH;
}
sub interr
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$w1="";
$c="";
$s1="";
$c1="";
$s1=$fm_set->Radiobutton(-text=>"Disulphide",-value=>"di",-variable=>\$w1,-command=>sub {$c1=$w1; intt($c1)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_set->Radiobutton(-text=>"Ionic",-value=>"ii",-variable=>\$w1,-command=>sub {$c1=$w1; intt($c1)},-font=>[-size =>'10'])->pack(-side=>'left');
$s1=$fm_set->Radiobutton(-text=>"Cation-Pi",-value=>"ci",-variable=>\$w1,-command=>sub {$c1=$w1; intt($c1)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_set->Radiobutton(-text=>"Polar",-value=>"hi",-variable=>\$w1,-command=>sub {$c1=$w1; intt($c1)},-font=>[-size =>'10'])->pack(-side=>'left');
$s1=$fm_set->Radiobutton(-text=>"Salt bridges",-value=>"sb",-variable=>\$w1,-command=>sub {$c1=$w1; intt($c1)},-font=>[-size =>'10'])->pack(-side=>'left');
}
sub intt
{
my($vijay)=@_;
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
if($vijay eq "di")
{
open(FH,$m);
@atm=();
@at=();
@a=();
@x1=();
@c1=();
@c2=();
@y1=();
@z1=();
while(<FH>)
{
if($_=~/^ATOM/)
{
if((substr($_,17,3) eq "CYS"))
{
if(substr($_,77,1) eq "S")
{
push(@a,$_);
push(@am,substr($_,7,4));
push(@at,substr($_,13,4));
push(@c1,substr($_,23,4));
push(@c2,substr($_,17,3));
push(@x1,substr($_,31,7));
push(@y1,substr($_,39,7));
push(@z1,substr($_,47,7));
}
}
}
}
$count=0; 
for($i=1;$i<scalar(@a);$i++)
{
for($j=$i+1;$j<scalar(@a);$j++)
{
$xans=($x1[$j-1]-$x1[$i-1])*($x1[$j-1]-$x1[$i-1]);
$yans=($y1[$j-1]-$y1[$i-1])*($y1[$j-1]-$y1[$i-1]);
$zans=($z1[$j-1]-$z1[$i-1])*($z1[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '2.2')
{
$count++;
}
else
{
"f";
}
}
}
$count++;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($count,9);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,4=>20,5=>20,6=>20,7=>20,8=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$count=0;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#$angleq[$i]=round($angleq[$i],3);
for($i=1;$i<scalar(@a);$i++)
{
for($j=$i+1;$j<scalar(@a);$j++)
{
$xans=($x1[$j-1]-$x1[$i-1])*($x1[$j-1]-$x1[$i-1]);
$yans=($y1[$j-1]-$y1[$i-1])*($y1[$j-1]-$y1[$i-1]);
$zans=($z1[$j-1]-$z1[$i-1])*($z1[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '2.2')
{
$arrayVar->{"$k,0"} = $am[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $at[$i-1];
$arrayVar->{"$k,3"} = $c2[$i-1];
$arrayVar->{"$k,4"} = $am[$j-1];
$arrayVar->{"$k,5"} = $c1[$j-1];
$arrayVar->{"$k,6"} = $at[$j-1];
$arrayVar->{"$k,7"} = $c2[$j-1];
$ans=round($ans,3);
$arrayVar->{"$k,8"} = $ans;
$count++;
$k++;
}
else
{
"f";
}
}
}
if($count == 0)
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Disulphide interaction Distance";
$tb=$fm_gr->Label(-text=>"No disulphide interactions exist")->pack(-side=>'top');
}
else
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Disulphide interaction Distance";
}
}
elsif($vijay eq "sb")
{
open(FH,$m);
@am1=();
@am2=();
@at1=();
@at2=();
@a=();
@b=();
@c1=();
@c2=();
@d1=();
@d2=();
@x1=();
@y1=();
@z1=();
@x2=();
@y2=();
@z2=();
while(<FH>)
{
if($_=~/^ATOM/)
{
if(((substr($_,17,3) eq "ASP") && (substr($_,13,2) eq "OD")) || ((substr($_,17,3) eq "GLU") && (substr($_,13,2) eq "OE")))
{
push(@a,$_);
push(@am1,substr($_,7,4));
push(@at1,substr($_,13,4));
push(@c1,substr($_,23,3));
push(@c2,substr($_,17,3));
push(@x1,substr($_,31,7));
push(@y1,substr($_,39,7));
push(@z1,substr($_,47,7));
}
elsif(((substr($_,17,3) eq "ARG") && (substr($_,13,2) eq "NH")) || ((substr($_,17,3) eq "LYS") && (substr($_,13,2) eq "NZ")) || ((substr($_,17,3) eq "HIS") && (substr($_,13,2) eq "NE")) || ((substr($_,17,3) eq "HIS") && (substr($_,13,2) eq "ND")))
{
push(@b,$_);
push(@am2,substr($_,7,4));
push(@at2,substr($_,13,4));
push(@d1,substr($_,23,3));
push(@d2,substr($_,17,3));
push(@x2,substr($_,31,7));
push(@y2,substr($_,39,7));
push(@z2,substr($_,47,7));
}
}
}
$count=0;
for($i=1;$i<=scalar(@a);$i++)
{
for($j=1;$j<=scalar(@b);$j++)
{
$xans=($x2[$j-1]-$x1[$i-1])*($x2[$j-1]-$x1[$i-1]);
$yans=($y2[$j-1]-$y1[$i-1])*($y2[$j-1]-$y1[$i-1]);
$zans=($z2[$j-1]-$z1[$i-1])*($z2[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '4')
{
$count++;
}
else
{
"n";
}
}
}
$count++;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($count,9);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,4=>20,5=>20,6=>20,7=>20,8=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$count=0;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#$angleq[$i]=round($angleq[$i],3);
for($i=1;$i<=scalar(@a);$i++)
{
for($j=1;$j<=scalar(@b);$j++)
{
$xans=($x2[$j-1]-$x1[$i-1])*($x2[$j-1]-$x1[$i-1]);
$yans=($y2[$j-1]-$y1[$i-1])*($y2[$j-1]-$y1[$i-1]);
$zans=($z2[$j-1]-$z1[$i-1])*($z2[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '4')
{
$arrayVar->{"$k,0"} = $am1[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $at1[$i-1];
$arrayVar->{"$k,3"} = $c2[$i-1];

$arrayVar->{"$k,4"} = $am2[$j-1];
$arrayVar->{"$k,5"} = $d1[$j-1];
$arrayVar->{"$k,6"} = $at2[$j-1];
$arrayVar->{"$k,7"} = $d2[$j-1];

$ans=round($ans,3);
$arrayVar->{"$k,8"} = $ans;
$count++;
$k++;
}
else
{
"n";
}
}
}
if($count == 0)
{
$tb=$fm_gr->Label(-text=>"No Salt bridges exist")->pack(-side=>'top');
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Salt bridge Distance";
}
else
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Salt bridge Distance";
}
}
elsif($vijay eq "ii")
{
open(FH,$m);
@am1=();
@am2=();
@at1=();
@at2=();
@a=();
@b=();
@c1=();
@c2=();
@d1=();
@d2=();
@x1=();
@y1=();
@z1=();
@x2=();
@y2=();
@z2=();
while(<FH>)
{
if($_=~/^ATOM/)
{
if((substr($_,17,3) eq "ARG") || (substr($_,17,3) eq "LYS") || (substr($_,17,3) eq "HIS"))
{
if(substr($_,77,1) eq 'N')
{
push(@a,$_);
push(@am1,substr($_,7,4));
push(@at1,substr($_,13,4));
push(@c1,substr($_,23,3));
push(@c2,substr($_,17,3));
push(@x1,substr($_,31,7));
push(@y1,substr($_,39,7));
push(@z1,substr($_,47,7));
}
}
elsif((substr($_,17,3) eq "ASP") || (substr($_,17,3) eq "GLU"))
{
if(substr($_,77,1) eq 'O')
{
push(@b,$_);
push(@am2,substr($_,7,4));
push(@at2,substr($_,13,4));
push(@d1,substr($_,23,3));
push(@d2,substr($_,17,3));
push(@x2,substr($_,31,7));
push(@y2,substr($_,39,7));
push(@z2,substr($_,47,7));
}
}
}
}
$count=0;
for($i=0;$i<scalar(@a);$i++)
{
for($j=0;$j<scalar(@b);$j++)
{
$xans=($x2[$j]-$x1[$i])*($x2[$j]-$x1[$i]);
$yans=($y2[$j]-$y1[$i])*($y2[$j]-$y1[$i]);
$zans=($z2[$j]-$z1[$i])*($z2[$j]-$z1[$i]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '6')
{
$count++;
}
else
{
next;
}
}
}
$count++;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($count,9);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,4=>20,5=>20,6=>20,7=>20,8=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$count=0;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
for($i=1;$i<scalar(@a);$i++)
{
for($j=1;$j<scalar(@b);$j++)
{
$xans=($x2[$j-1]-$x1[$i-1])*($x2[$j-1]-$x1[$i-1]);
$yans=($y2[$j-1]-$y1[$i-1])*($y2[$j-1]-$y1[$i-1]);
$zans=($z2[$j-1]-$z1[$i-1])*($z2[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '6')
{
$arrayVar->{"$k,0"} = $am1[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $at1[$i-1];
$arrayVar->{"$k,3"} = $c2[$i-1];
$arrayVar->{"$k,4"} = $am2[$j-1];
$arrayVar->{"$k,5"} = $d1[$j-1];
$arrayVar->{"$k,6"} = $at2[$j-1];
$arrayVar->{"$k,7"} = $d2[$j-1];
$ans=round($ans,3);
$arrayVar->{"$k,8"} = $ans;
$count++;
$k++;
}
else
{
next;
}
}
}
if($count == 0)
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Ionic interaction Distance";
$tb=$fm_gr->Label(-text=>"No ionic interactions exist")->pack(-side=>'top');
}
else
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Ionic interaction Distance";
}
}
elsif($vijay eq "ci")
{
open(FH,$m);
@am1=();
@am2=();
@at1=();
@at2=();
@a=();
@b=();
@c1=();
@c2=();
@d1=();
@d2=();
@x1=();
@y1=();
@z1=();
@x2=();
@y2=();
@z2=();
while(<FH>)
{
if($_=~/^ATOM/)
{
if((substr($_,17,3) eq "ARG") || (substr($_,17,3) eq "LYS"))
{
if((substr($_,13,4) eq "CZ  ")  || (substr($_,13,4) eq "NZ  "))
{
push(@a,$_);
push(@am1,substr($_,7,4));
push(@at1,substr($_,13,4));
push(@c1,substr($_,23,3));
push(@c2,substr($_,17,3));
push(@x1,substr($_,31,7));
push(@y1,substr($_,39,7));
push(@z1,substr($_,47,7));
}
}
elsif((substr($_,17,3) eq "PHE") || (substr($_,17,3) eq "TYR") || (substr($_,17,3) eq "TRP"))
{
if((substr($_,13,4) eq "CZ  "))
{
push(@b,$_);
push(@am2,substr($_,7,4));
push(@at2,substr($_,13,4));
push(@d1,substr($_,23,3));
push(@d2,substr($_,17,3));
push(@x2,substr($_,31,7));
push(@y2,substr($_,39,7));
push(@z2,substr($_,47,7));
}
}
}
}
$count=0;
for($i=1;$i<=scalar(@a);$i++)
{
for($j=1;$j<=scalar(@b);$j++)
{
$xans=($x2[$j-1]-$x1[$i-1])*($x2[$j-1]-$x1[$i-1]);
$yans=($y2[$j-1]-$y1[$i-1])*($y2[$j-1]-$y1[$i-1]);
$zans=($z2[$j-1]-$z1[$i-1])*($z2[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '6')
{
$count++;
}
else
{
"n";
}
}
}
$count++;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($count,9);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,4=>20,5=>20,6=>20,7=>20,8=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$count=0;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#$angleq[$i]=round($angleq[$i],3);
for($i=1;$i<=scalar(@a);$i++)
{
for($j=1;$j<=scalar(@b);$j++)
{
$xans=($x2[$j-1]-$x1[$i-1])*($x2[$j-1]-$x1[$i-1]);
$yans=($y2[$j-1]-$y1[$i-1])*($y2[$j-1]-$y1[$i-1]);
$zans=($z2[$j-1]-$z1[$i-1])*($z2[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '6')
{
$arrayVar->{"$k,0"} = $am1[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $at1[$i-1];
$arrayVar->{"$k,3"} = $c2[$i-1];

$arrayVar->{"$k,4"} = $am2[$j-1];
$arrayVar->{"$k,5"} = $d1[$j-1];
$arrayVar->{"$k,6"} = $at2[$j-1];
$arrayVar->{"$k,7"} = $d2[$j-1];

$ans=round($ans,3);
$arrayVar->{"$k,8"} = $ans;
$count++;
$k++;
}
else
{
"n";
}
}
}
if($count == 0)
{
$tb=$fm_gr->Label(-text=>"No Cation-Pi interactions exist")->pack(-side=>'top');
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Cation-Pi interaction Distance";
}
else
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Cation-Pi interaction Distance";
}
}
elsif($vijay eq "hi")
{
open(FH,$m);
@am=();
@a=();
@at=();
@x1=();
@c1=();
@c2=();
@y1=();
@z1=();
while(<FH>)
{
if($_=~/^ATOM/)
{
if((substr($_,17,3) eq "ALA") || (substr($_,17,3) eq "VAL") || (substr($_,17,3) eq "LEU") || (substr($_,17,3) eq "ILE") || (substr($_,17,3) eq "MET") || (substr($_,17,3) eq "PHE") || (substr($_,17,3) eq "TRP") || (substr($_,17,3) eq "PRO") || (substr($_,17,3) eq "TYR"))
{
if((substr($_,13,4) eq "CB  "))
{
push(@a,$_);
push(@am,substr($_,7,4));
push(@at,substr($_,13,4));
push(@c1,substr($_,23,4));
push(@c2,substr($_,17,3));
push(@x1,substr($_,31,7));
push(@y1,substr($_,39,7));
push(@z1,substr($_,47,7));
}
}
}
}
$count=0; 
for($i=1;$i<scalar(@a);$i++)
{
for($j=$i+1;$j<scalar(@a);$j++)
{
$xans=($x1[$j-1]-$x1[$i-1])*($x1[$j-1]-$x1[$i-1]);
$yans=($y1[$j-1]-$y1[$i-1])*($y1[$j-1]-$y1[$i-1]);
$zans=($z1[$j-1]-$z1[$i-1])*($z1[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '5')
{
$count++;
}
else
{
"f";
}
}
}
$count++;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($count,9);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,4=>20,5=>20,6=>20,7=>20,8=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$count=0;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#$angleq[$i]=round($angleq[$i],3);
for($i=1;$i<scalar(@a);$i++)
{
for($j=$i+1;$j<scalar(@a);$j++)
{
$xans=($x1[$j-1]-$x1[$i-1])*($x1[$j-1]-$x1[$i-1]);
$yans=($y1[$j-1]-$y1[$i-1])*($y1[$j-1]-$y1[$i-1]);
$zans=($z1[$j-1]-$z1[$i-1])*($z1[$j-1]-$z1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
if($ans < '5')
{
$arrayVar->{"$k,0"} = $am[$i-1];
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,2"} = $at[$i-1];
$arrayVar->{"$k,3"} = $c2[$i-1];
$arrayVar->{"$k,4"} = $am[$j-1];
$arrayVar->{"$k,5"} = $c1[$j-1];
$arrayVar->{"$k,6"} = $at[$i-1];
$arrayVar->{"$k,7"} = $c2[$j-1];
$ans=round($ans,3);
$arrayVar->{"$k,8"} = $ans;
$count++;
$k++;
}
else
{
"f";
}
}
}
if($count == 0)
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Hydrophobic interaction Distance";
$tb=$fm_gr->Label(-text=>"No hydrophobic interactions exist")->pack(-side=>'top');
}
else
{
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Residue No.";
$arrayVar->{"0,2"} = "Atom Name";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Atom No.";
$arrayVar->{"0,5"} = "Residue No.";
$arrayVar->{"0,6"} = "Atom Name";
$arrayVar->{"0,7"} = "Residue 2";
$arrayVar->{"0,8"} = "Hydrophobic interaction Distance";
}
}
}
##################################################
#####          Distance finder               #####
#####   Calculates the CA, CB and atom dist  #####
##################################################
sub dss
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$p1="";
$s1="";
$c="";
$s1=$fm_set->Radiobutton(-text=>"C alpha-C alpha",-value=>"CA",-variable=>\$p1,-command=>sub {$c=$p1; dsss($c)},-font=>[-size =>'10'])->pack(-side=>'left');  
$s1=$fm_set->Radiobutton(-text=>"C beeta-C beeta",-value=>"CB",-variable=>\$p1,-command=>sub {$c=$p1; dsss($c)},-font=>[-size =>'10'])->pack(-side=>'left');
$s1=$fm_set->Radiobutton(-text=>"Between 2 Atoms",-value=>"2a",-variable=>\$p1,-command=>sub {$c=$p1; dsss($c)},-font=>[-size =>'10'])->pack(-side=>'left');
}
sub dsss
{
my($ans)=@_;
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
if(($ans eq "CA") || ($ans eq "CB"))
{
open(FG,$m);
@cd=();
@chainsd=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@cd=split(/,/,$_);
push(@chainsd,@cd);
}
}
}
close FG;
$s="";
$p="";
$c="";
for($i=0;$i<scalar(@chainsd);$i++)
{
$s=$fm_gr1->Radiobutton(-text=>$chainsd[$i],-value=>"$chainsd[$i]",-variable=>\$p,-command=>sub {$c=$p; saba($c,$ans)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
}
else
{
my $dropdown_value;
my $dropdown = $fm_gr1->BrowseEntry(-label => "                                      				                                     From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(DELE,$m);
@fainishs=();
@baegins=();
while(<DELE>)
{
if($_=~/^ATOM/)
{
push(@baegins,substr($_,6,5));
push(@fainishs,substr($_,6,5));
}
}
close DELE;
foreach (@baegins) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_gr1->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach (@fainishs) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_gr1->Label(-text=>"       ")->pack(-anchor=>'nw',-side=>'left');
$but=$fm_gr1->Button(-text=>"Go",-command=>sub{$fs=$dropdown_value; 
$es=$dropdown_valueq;
calculate($fs,$es)})->pack(-anchor=>'nw',-side=>'left');
}
sub calculate
{
my($a,$b)=@_;
$txt1->delete('1.0','end');
@xcor=();
@ycor=();
@zcor=();
open(CAL,$m);
while(<CAL>)
{
if($_=~/^ATOM/)
{
if((substr($_,6,5) == $a))
{
$xcor[0]=substr($_,31,7);
$ycor[0]=substr($_,39,7);
$zcor[0]=substr($_,47,7);
}
}
next;
}
close CAL;
open(CAL1,$m);
while(<CAL1>)
{
if($_=~/^ATOM/)
{
if((substr($_,6,5) == $b))
{
$xcor[1]=substr($_,31,7);
$ycor[1]=substr($_,39,7);
$zcor[1]=substr($_,47,7);
}
}
next;
}
close CAL1;
$xans="";
$yans="";
$zans="";
$xans=($xcor[0]-$xcor[1])*($xcor[0]-$xcor[1]);
$yans=($ycor[0]-$ycor[1])*($ycor[0]-$ycor[1]);
$zans=($zcor[0]-$zcor[1])*($zcor[0]-$zcor[1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
$txt1->insert('1.0',"The distance between atom no $a and $b is $ans");
}
}
sub saba
{
my($cc,$ss)=@_;
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr1);
open(SAU,$m);
$sa="";
@c1=();
@c2=();
@x=();
@y=();
@z=();
while(<SAU>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $cc)
{
if(substr($_,13,2) eq $ss)
{
$sa.=$_;
push(@c1,substr($_,17,3));
push(@c2,substr($_,23,3));
push(@x,substr($_,31,7));
push(@y,substr($_,39,7));
push(@z,substr($_,47,7));
}
}
}
}
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$txt->insert('1.0',$sa);
close SAU;
$n=(scalar(@c1)*scalar(@c2));
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($n,5);
$arrayVar->{"0,0"} = "Residue No.";
$arrayVar->{"0,1"} = "Residue 1";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "Residue 2";
$arrayVar->{"0,4"} = "$ss-$ss Distance";
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>10,2=>10,3=>20,4=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$ans="";
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#9561
#$angleq[$i]=round($angleq[$i],3);
#$angle[$i-1]=round($angle[$i-1],3);
for($i=1;$i<=scalar(@c1);$i++)
{
for($j=1;$j<=scalar(@c1);$j++)
{
$xans="";
$yans="";
$zans="";
$arrayVar->{"$k,1"} = $c1[$i-1];
$arrayVar->{"$k,3"} = $c1[$j];
$arrayVar->{"$k,0"} = $c2[$i-1];
$arrayVar->{"$k,2"} = $c2[$j];
$xans=($x[$j]-$x[$i-1])*($x[$j]-$x[$i-1]);
$yans=($y[$j]-$y[$i-1])*($y[$j]-$y[$i-1]);
$zans=($z[$j]-$z[$i-1])*($z[$j]-$z[$i-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
$arrayVar->{"$k,4"} = $ans;
$k++;
}
}
}
##################################################
#####            Ligand Distance             #####
#####               calculator               #####
##################################################
sub ligdis
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
open(LI,$m);
$line="";
while(<LI>)
{
if($_=~/^ATOM/)
{
$line.=$_;
}
}
close LI;
$txt->insert('1.0',"$line");

open(LWI,$m);
$sline="";
while(<LWI>)
{
if($_=~/^HETATM/)
{
$sline.=$_;
}
}
close LWI;
$txt1->insert('1.0',"$sline");

open(DD,$m);
$ro=0;
@atmno=();
@atmname=();
@resname=();
@axcor=();
@aycor=();
@azcor=();
while(<DD>)
{
if($_=~/^ATOM/)
{
push(@atmno,substr($_,7,4));

push(@atmname,substr($_,13,3));

push(@resname,substr($_,17,3));

push(@axcor,substr($_,31,7));

push(@aycor,substr($_,39,7));

push(@azcor,substr($_,47,7));
$ro++;
}
}
close DD;

open(DF,$m);
$ro1=0;
@hetno=();
@hetaname=();
@hetrname=();
@hxcor=();
@hycor=();
@hzcor=();
while(<DF>)
{
if($_=~/^HETATM/)
{
push(@hetno,substr($_,7,4));

push(@hetaname,substr($_,12,5));

push(@hetrname,substr($_,17,3));

push(@hxcor,substr($_,31,7));

push(@hycor,substr($_,39,7));

push(@hzcor,substr($_,47,7));
$ro1++;
}
}
close DF;
$n=$ro*$ro1;
my $topsss = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($n,7);
foreach my $row (0..($rows-1))
{
$arrayVar->{"$row,0"} = "$row";
}
$arrayVar->{"0,0"} = "Atom No.";
$arrayVar->{"0,1"} = "Atom Name";
$arrayVar->{"0,2"} = "Residue Name";
$arrayVar->{"0,3"} = "Hetra No.";
$arrayVar->{"0,4"} = "Hetra Atom Name";
$arrayVar->{"0,5"} = "Hetra Atom Residue Name";
$arrayVar->{"0,6"} = "Distance";
$k=1;
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;
}
my $tss=$topsss->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$tss->rowHeight(0,1); 
$tss->tagRow('title',0); 
$tss->tagConfigure('title',-bd=>2,-relief=>'raised'); 
$tss->activate("1,0"); 
$tss->colWidth(0=>15,1=>20,2=>20,3=>15,4=>15,5=>25,6=>20);
$tss->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$tss->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}

for($i=1;$i<=scalar(@atmno);$i++)
{
for($j=1;$j<=scalar(@hetno);$j++)
{
$xans="";
$yans="";
$zans="";
$arrayVar->{"$k,0"} = $atmno[$i-1];
$arrayVar->{"$k,1"} = $atmname[$i-1];
$arrayVar->{"$k,2"} = $resname[$i-1];
$arrayVar->{"$k,3"} = $hetno[$j-1];
$arrayVar->{"$k,4"} = $hetaname[$j-1];
$arrayVar->{"$k,5"} = $hetrname[$j-1];
$xans=($axcor[$i-1]-$hxcor[$j-1])*($axcor[$i-1]-$hxcor[$j-1]);
$yans=($aycor[$i-1]-$hycor[$j-1])*($aycor[$i-1]-$hycor[$j-1]);
$zans=($azcor[$i-1]-$hzcor[$j-1])*($azcor[$i-1]-$hzcor[$j-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
push(@inference,$ans);
$arrayVar->{"$k,6"} = $ans;
$k++;
}
}
}
##################################################
#####         Secondary Strucutre            #####
#####               predictor                #####
##################################################
sub sss
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);open(FH,$m);
$txt1->delete('1.0','end');
$txt1->delete('1.0','end');
@rn=();@nx=();@ny=();@nz=();@rca=();@cax=();@cay=();@caz=();@rc=();@cx=();@cy=();@cz=();
$nc=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,3) eq 'N  ')
{
$nc++;
push(@rn,substr($_,23,3));
push(@nx,substr($_,31,7));
push(@ny,substr($_,39,7));
push(@nz,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rca,substr($_,23,3));
push(@cax,substr($_,31,7));
push(@cay,substr($_,39,7));
push(@caz,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rc,substr($_,23,3));
push(@cx,substr($_,31,7));
push(@cy,substr($_,39,7));
push(@cz,substr($_,47,7));
}
}
}
@v1x=();@v1y=();@v1z=();
@v2x=();@v2y=();@v2z=();
@v3x=();@v3y=();@v3z=();
for($i=1;$i<$nc;$i++)
{
push(@v1x,$nx[$i]-$cx[$i-1]);
push(@v1y,$ny[$i]-$cy[$i-1]);
push(@v1z,$nz[$i]-$cz[$i-1]);
push(@v2x,$cax[$i]-$nx[$i]);
push(@v2y,$cay[$i]-$ny[$i]);
push(@v2z,$caz[$i]-$nz[$i]);
push(@v3x,$cx[$i]-$cax[$i]);
push(@v3y,$cy[$i]-$cay[$i]);
push(@v3z,$cz[$i]-$caz[$i]);
}
@pyz=();@pxz=();@pxy=();
@qyz=();@qxz=();@qxy=();
for($i=0;$i<$nc;$i++)
{
push(@pyz,$v1y[$i]*$v2z[$i]-$v1z[$i]*$v2y[$i]);
push(@pxz,$v1z[$i]*$v2x[$i]-$v1x[$i]*$v2z[$i]);
push(@pxy,$v1x[$i]*$v2y[$i]-$v1y[$i]*$v2x[$i]);
push(@qyz,$v2y[$i]*$v3z[$i]-$v2z[$i]*$v3y[$i]);
push(@qxz,$v2z[$i]*$v3x[$i]-$v2x[$i]*$v3z[$i]);
push(@qxy,$v2x[$i]*$v3y[$i]-$v2y[$i]*$v3x[$i]);
}
@r1=();@r2=();@r3=();
for($i=0;$i<$nc;$i++)
{
push(@r1,$pzx[$i]*$qxy[$i]-$pxy[$i]*$qzx[$i]);
push(@r2,$pxy[$i]*$qyz[$i]-$pyz[$i]*$qxy[$i]);
push(@r3,$pyz[$i]*$qzx[$i]-$pzx[$i]*$qyz[$i]);
}
@l=();@lp=();@lq=();@cosval=();@sinval=();@angle=();
for($i=0;$i<$nc-1;$i++)
{
$sum[$i]=$pyz[$i]*$qyz[$i]+$pxz[$i]*$qxz[$i]+$pxy[$i]*$qxy[$i];
$lp[$i]=sqrt($pyz[$i]*$pyz[$i]+$pxz[$i]*$pxz[$i]+$pxy[$i]*$pxy[$i]);
$lq[$i]=sqrt($qyz[$i]*$qyz[$i]+$qxz[$i]*$qxz[$i]+$qxy[$i]*$qxy[$i]);
$l[$i]=$lp[$i]*$lq[$i];
}
for($i=0;$i<$nc-1;$i++)
{
$cosval[$i]+=$sum[$i]/$l[$i];
$sinsqval[$i]=1-($cosval[$i]*$cosval[$i]);
if($sinsqval[$i]<0)
{
$sinsqval[$i]=0;
}
$sinval[$i]=sqrt($sinsqval[$i]);
$angle[$i]=-(atan2($sinval[$i],$cosval[$i])*57.29578);
}
@sum1=();
for($i=0;$i<$nc-1;$i++)
{
$sum1[$i]=$r1[$i]*$v2x[$i]+$r2[$i]*$v2y[$i]+$r3[$i]*$v3z[$i];
if($sum1[$i] > 0)
{
$angle[$i] = -$angle[$i];
}
}


open(FH,$m);
@rn=();@nx=();@ny=();@nz=();@rca=();@cax=();@cay=();@caz=();@rc=();@cx=();@cy=();@cz=();
$nc=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,3) eq 'N  ')
{
$nc++;
push(@rn,substr($_,23,3));
push(@nx,substr($_,31,7));
push(@ny,substr($_,39,7));
push(@nz,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rca,substr($_,23,3));
push(@cax,substr($_,31,7));
push(@cay,substr($_,39,7));
push(@caz,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rc,substr($_,23,3));
push(@cx,substr($_,31,7));
push(@cy,substr($_,39,7));
push(@cz,substr($_,47,7));
}
}
}
@v1x=();@v1y=();@v1z=();
@v2x=();@v2y=();@v2z=();
@v3x=();@v3y=();@v3z=();
for($i=1;$i<$nc;$i++)
{
push(@v1x,$cax[$i-1]-$nx[$i-1]);
push(@v1y,$cay[$i-1]-$ny[$i-1]);
push(@v1z,$caz[$i-1]-$nz[$i-1]);
push(@v2x,$cx[$i-1]-$cax[$i-1]);
push(@v2y,$cy[$i-1]-$cay[$i-1]);
push(@v2z,$cz[$i-1]-$caz[$i-1]);
push(@v3x,$nx[$i]-$cx[$i-1]);
push(@v3y,$ny[$i]-$cy[$i-1]);
push(@v3z,$nz[$i]-$cz[$i-1]);
}
@pyz=();@pxz=();@pxy=();
@qyz=();@qxz=();@qxy=();
for($i=0;$i<$nc;$i++)
{
push(@pyz,$v1y[$i]*$v2z[$i]-$v1z[$i]*$v2y[$i]);
push(@pxz,$v1z[$i]*$v2x[$i]-$v1x[$i]*$v2z[$i]);
push(@pxy,$v1x[$i]*$v2y[$i]-$v1y[$i]*$v2x[$i]);
push(@qyz,$v2y[$i]*$v3z[$i]-$v2z[$i]*$v3y[$i]);
push(@qxz,$v2z[$i]*$v3x[$i]-$v2x[$i]*$v3z[$i]);
push(@qxy,$v2x[$i]*$v3y[$i]-$v2y[$i]*$v3x[$i]);
}
@r1=();@r2=();@r3=();
for($i=0;$i<$nc;$i++)
{
push(@r1,$pzx[$i]*$qxy[$i]-$pxy[$i]*$qzx[$i]);
push(@r2,$pxy[$i]*$qyz[$i]-$pyz[$i]*$qxy[$i]);
push(@r3,$pyz[$i]*$qzx[$i]-$pzx[$i]*$qyz[$i]);
}
@l=();@lp=();@lq=();@cosval=();@sinval=();@angle=();
for($i=0;$i<$nc-1;$i++)
{
$sum[$i]=$pyz[$i]*$qyz[$i]+$pxz[$i]*$qxz[$i]+$pxy[$i]*$qxy[$i];
$lp[$i]=sqrt($pyz[$i]*$pyz[$i]+$pxz[$i]*$pxz[$i]+$pxy[$i]*$pxy[$i]);
$lq[$i]=sqrt($qyz[$i]*$qyz[$i]+$qxz[$i]*$qxz[$i]+$qxy[$i]*$qxy[$i]);
$l[$i]=$lp[$i]*$lq[$i];
}
for($i=0;$i<$nc-1;$i++)
{
$cosval[$i]+=$sum[$i]/$l[$i];
$sinsqval[$i]=1-($cosval[$i]*$cosval[$i]);
if($sinsqval[$i]<0)
{
$sinsqval[$i]=0;
}
$sinval[$i]=sqrt($sinsqval[$i]);
$angle1[$i]=-(atan2($sinval[$i],$cosval[$i])*57.29578);
}
@sum1=();
for($i=0;$i<$nc-1;$i++)
{
$sum1[$i]=$r1[$i]*$v2x[$i]+$r2[$i]*$v2y[$i]+$r3[$i]*$v3z[$i];
#print $sum1[$i],"\n";
if($sum1[$i] > 0)
{
$angle1[$i] = -$angle1[$i];
}
}

$n=scalar(@angle1);

my $topss = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($n,6);
foreach my $row (0..($rows-1))
{
$arrayVar->{"$row,0"} = "$row";
}
$arrayVar->{"0,0"} = "Residue No.";
$arrayVar->{"0,1"} = "Residue 1";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "Residue 1";
$arrayVar->{"0,4"} = "Phi and Psi angle Difference";
$arrayVar->{"0,5"} = "Inference";
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;
}
my $tsss=$topss->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$tsss->rowHeight(0,1); 
$tsss->tagRow('title',0); 
$tsss->tagConfigure('title',-bd=>2,-relief=>'raised'); 
$tsss->activate("1,0"); 
$tsss->colWidth(0=>18,1=>23,2=>23,3=>18,4=>97);
$tsss->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$tsss->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
open(DO4,$m);
@residue1=();
@resno=();
while(<DO4>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,2) eq "CA")
{
push(@residue1,substr($_,17,3));
push(@resno,substr($_,23,3));
}
}
}
close DO4;
$k=1;
$helix="";
$sheet="";
$dis="";
$display="";
$display.="The Regions are:\n\n";
for($i=0;$i<scalar(@angle1);$i++)
{
$xans="";
$yans="";
$arrayVar->{"$k,0"} = $resno[$i];
$arrayVar->{"$k,1"} = $residue1[$i];
$arrayVar->{"$k,2"} = $resno[$i+1];
$arrayVar->{"$k,3"} = $residue1[$i+1];




$xans=($angle[$i]-$angle[$i+1])*($angle[$i]-$angle[$i-1]);
$yans=($angle1[$i]-$angle1[$i+1])*($angle1[$i]-$angle1[$i+1]);
$ans=sqrt($xans+$yans);
$ans=round($ans,3);
push(@inference,$ans);
$arrayVar->{"$k,4"} = $ans;
$z++;
if($ans <= 30)
{
$arrayVar->{"$k,5"} = "Helical";
$helix.="$resno[$i]:$residue1[$i] ";
}
elsif($ans >=30 && $ans <= 100)
{
$arrayVar->{"$k,5"} = "Sheet";
$sheet.="$resno[$i]:$residue1[$i] ";
}
else
{
$arrayVar->{"$k,5"} = "Disordered";
$dis.="$resno[$i]:$residue1[$i] ";
}
$k++;
}
$txt1->delete('1.0','end');
$display.="The Helical regions are: \n";
$display.="$helix\n\n";
$display.="The Sheet regions are: \n";
$display.="$sheet\n\n";
$display.="The Disodered regions are: \n";
$display.="$dis\n\n";
$txt1->insert('1.0',"$display");
}
##################################################
#####              RAMACANDRAN PLOT          #####
#####      Can calculate the PHI,PSI angle   #####
##################################################
sub rplot
{
if($m ne "")
{
$mw_ram=MainWindow->new(-title=>'Ramachandran Explorer');
$mw_ram->geometry(($mw_ram->maxsize())[0] .'x'.($mw_ram->maxsize())[1]);
$frame1_ram=$mw_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$frame2_ram=$mw_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$r=$frame2_ram->Canvas(-width =>686, -height =>686); 
$r->pack;
$frame1_ram->pack(-anchor=>'nw',-side=>'left',-expand=>0);
$frame2_ram->pack(-anchor=>'nw',-side=>'left',-expand=>0);
$subframe1_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe1_ram->pack(-side=>'top',-expand=>0,-fill=>'x');
$subframe2_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe2_ram->pack(-side=>'top',-expand=>0,-fill=>'x');
$subframe3_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe3_ram->pack(-side=>'top',-expand=>0,-fill=>'x');
$r->createRectangle(0, 0,19,19,-fill=>'yellow');
$r->createRectangle(0,19,19,38,-fill=>'yellow');
$r->createRectangle(0,38,19,57,-fill=>'yellow');
$r->createRectangle(0,57,19,76,-fill=>'yellow');
$r->createRectangle(0,76,19,95,-fill=>'yellow');
$r->createRectangle(0,95,19,114,-fill=>'yellow');
$r->createRectangle(0,114,19,133,-fill=>'yellow');
$r->createRectangle(0,133,19,152,-fill=>'yellow');
$r->createRectangle(0,152,19,171,-fill=>'yellow');
$r->createRectangle(0,171,19,190,-fill=>'yellow');
$r->createRectangle(0,190,19,209,-fill=>'yellow');
$r->createRectangle(0,209,19,228,-fill=>"#DAA520");
$r->createRectangle(0,228,19,247,-fill=>"#DAA520");
$r->createRectangle(0,247,19,266,-fill=>"#DAA520");
$r->createRectangle(0,266,19,285,-fill=>"#DAA520");
$r->createRectangle(0,285,19,304,-fill=>"#DAA520");
$r->createRectangle(0,304,19,323,-fill=>"#DAA520");
$r->createRectangle(0,323,19,342,-fill=>"#DAA520");
$r->createRectangle(0,342,19,361,-fill=>"#DAA520");
$r->createRectangle(0,361,19,380,-fill=>"#DAA520");
$r->createRectangle(0,380,19,399,-fill=>"#DAA520");
$r->createRectangle(0,399,19,418,-fill=>"#DAA520");
$r->createRectangle(0,418,19,437,-fill=>"#DAA520");
$r->createRectangle(0,437,19,456,-fill=>"#DAA520");
$r->createRectangle(0,456,19,475,-fill=>'yellow');
$r->createRectangle(0,475,19,494,-fill=>"#DAA520");
$r->createRectangle(0,494,19,513,-fill=>"#DAA520");
$r->createRectangle(0,513,19,532,-fill=>'white');
$r->createRectangle(0,532,19,551,-fill=>'white');
$r->createRectangle(0,551,19,570,-fill=>'white');
$r->createRectangle(0,570,19,589,-fill=>"#DAA520");
$r->createRectangle(0,589,19,608,-fill=>"#DAA520");
$r->createRectangle(0,608,19,627,-fill=>"#DAA520");
$r->createRectangle(0,627,19,646,-fill=>"#DAA520");
$r->createRectangle(0,646,19,665,-fill=>"#DAA520");
$r->createRectangle(0,665,19,684,-fill=>'yellow');
#i=2;
$r->createRectangle(19,0,38,19,-fill=>'red');
$r->createRectangle(19,19,38,38,-fill=>'red');
$r->createRectangle(19,38,38,57,-fill=>'red');
$r->createRectangle(19,57,38,76,-fill=>'yellow');
$r->createRectangle(19,76,38,95,-fill=>'yellow');
$r->createRectangle(19,95,38,114,-fill=>'yellow');
$r->createRectangle(19,114,38,133,-fill=>'yellow');
$r->createRectangle(19,133,38,152,-fill=>'yellow');
$r->createRectangle(19,152,38,171,-fill=>'yellow');
$r->createRectangle(19,171,38,190,-fill=>'yellow');
$r->createRectangle(19,190,38,209,-fill=>'yellow');
$r->createRectangle(19,209,38,228,-fill=>'yellow');
$r->createRectangle(19,228,38,247,-fill=>"#DAA520");
$r->createRectangle(19,247,38,266,-fill=>"#DAA520");
$r->createRectangle(19,266,38,285,-fill=>'yellow');
$r->createRectangle(19,285,38,304,-fill=>'yellow');
$r->createRectangle(19,304,38,323,-fill=>'yellow');
$r->createRectangle(19,323,38,342,-fill=>'yellow');
$r->createRectangle(19,342,38,361,-fill=>'yellow');
$r->createRectangle(19,361,38,380,-fill=>'yellow');
$r->createRectangle(19,380,38,399,-fill=>"#DAA520");
$r->createRectangle(19,399,38,418,-fill=>"#DAA520");
$r->createRectangle(19,418,38,437,-fill=>"#DAA520");
$r->createRectangle(19,437,38,456,-fill=>'yellow');
$r->createRectangle(19,456,38,475,-fill=>'yellow');
$r->createRectangle(19,475,38,494,-fill=>"#DAA520");
$r->createRectangle(19,494,38,513,-fill=>"#DAA520");
$r->createRectangle(19,513,38,532,-fill=>"#DAA520");
$r->createRectangle(19,532,38,551,-fill=>'white');
$r->createRectangle(19,551,38,570,-fill=>'white');
$r->createRectangle(19,570,38,589,-fill=>"#DAA520");
$r->createRectangle(19,589,38,608,-fill=>"#DAA520");
$r->createRectangle(19,608,38,627,-fill=>'yellow');
$r->createRectangle(19,627,38,646,-fill=>'yellow');
$r->createRectangle(19,646,38,665,-fill=>'yellow');
$r->createRectangle(19,665,38,684,-fill=>'yellow');
#i=3;
$r->createRectangle(38,0,57,19,-fill=>'red');
$r->createRectangle(38,19,57,38,-fill=>'red');
$r->createRectangle(38,38,57,57,-fill=>'red');
$r->createRectangle(38,57,57,76,-fill=>'red');
$r->createRectangle(38,76,57,95,-fill=>'red');
$r->createRectangle(38,95,57,114,-fill=>'red');
$r->createRectangle(38,114,57,133,-fill=>'yellow');
$r->createRectangle(38,133,57,152,-fill=>'yellow');
$r->createRectangle(38,152,57,171,-fill=>'yellow');
$r->createRectangle(38,171,57,190,-fill=>'yellow');
$r->createRectangle(38,190,57,209,-fill=>'yellow');
$r->createRectangle(38,209,57,228,-fill=>'yellow');
$r->createRectangle(38,228,57,247,-fill=>'yellow');
$r->createRectangle(38,247,57,266,-fill=>'yellow');
$r->createRectangle(38,266,57,285,-fill=>'yellow');
$r->createRectangle(38,285,57,304,-fill=>'yellow');
$r->createRectangle(38,304,57,323,-fill=>'yellow');
$r->createRectangle(38,323,57,342,-fill=>'yellow');
$r->createRectangle(38,342,57,361,-fill=>'yellow');
$r->createRectangle(38,361,57,380,-fill=>'yellow');
$r->createRectangle(38,380,57,399,-fill=>'yellow');
$r->createRectangle(38,399,57,418,-fill=>'yellow');
$r->createRectangle(38,418,57,437,-fill=>"#DAA520");
$r->createRectangle(38,437,57,456,-fill=>'yellow');
$r->createRectangle(38,456,57,475,-fill=>"#DAA520");
$r->createRectangle(38,475,57,494,-fill=>"#DAA520");
$r->createRectangle(38,494,57,513,-fill=>"#DAA520");
$r->createRectangle(38,513,57,532,-fill=>"#DAA520");
$r->createRectangle(38,532,57,551,-fill=>'white');
$r->createRectangle(38,551,57,570,-fill=>'white');
$r->createRectangle(38,570,57,589,-fill=>"#DAA520");
$r->createRectangle(38,589,57,608,-fill=>"#DAA520");
$r->createRectangle(38,608,57,627,-fill=>'yellow');
$r->createRectangle(38,627,57,646,-fill=>'yellow');
$r->createRectangle(38,646,57,665,-fill=>'yellow');
$r->createRectangle(38,665,57,684,-fill=>'yellow');
#i=4;
$r->createRectangle(57,0,76,19,-fill=>'red');
$r->createRectangle(57,19,76,38,-fill=>'red');
$r->createRectangle(57,38,76,57,-fill=>'red');
$r->createRectangle(57,57,76,76,-fill=>'red');
$r->createRectangle(57,76,76,95,-fill=>'red');
$r->createRectangle(57,95,76,114,-fill=>'red');
$r->createRectangle(57,114,76,133,-fill=>'red');
$r->createRectangle(57,133,76,152,-fill=>'yellow');
$r->createRectangle(57,152,76,171,-fill=>'yellow');
$r->createRectangle(57,171,76,190,-fill=>'yellow');
$r->createRectangle(57,190,76,209,-fill=>'yellow');
$r->createRectangle(57,209,76,228,-fill=>'yellow');
$r->createRectangle(57,228,76,247,-fill=>'yellow');
$r->createRectangle(57,247,76,266,-fill=>'yellow');
$r->createRectangle(57,266,76,285,-fill=>'yellow');
$r->createRectangle(57,285,76,304,-fill=>'yellow');
$r->createRectangle(57,304,76,323,-fill=>'yellow');
$r->createRectangle(57,323,76,342,-fill=>'yellow');
$r->createRectangle(57,342,76,361,-fill=>'yellow');
$r->createRectangle(57,361,76,380,-fill=>'yellow');
$r->createRectangle(57,380,76,399,-fill=>'yellow');
$r->createRectangle(57,399,76,418,-fill=>'yellow');
$r->createRectangle(57,418,76,437,-fill=>'yellow');
$r->createRectangle(57,437,76,456,-fill=>'yellow');
$r->createRectangle(57,456,76,475,-fill=>'yellow');
$r->createRectangle(57,475,76,494,-fill=>'yellow');
$r->createRectangle(57,494,76,513,-fill=>"#DAA520");
$r->createRectangle(57,513,76,532,-fill=>"#DAA520");
$r->createRectangle(57,532,76,551,-fill=>"#DAA520");
$r->createRectangle(57,551,76,570,-fill=>"#DAA520");
$r->createRectangle(57,570,76,589,-fill=>"#DAA520");
$r->createRectangle(57,589,76,608,-fill=>"#DAA520");
$r->createRectangle(57,608,76,627,-fill=>'yellow');
$r->createRectangle(57,627,76,646,-fill=>'yellow');
$r->createRectangle(57,646,76,665,-fill=>'yellow');
$r->createRectangle(57,665,76,684,-fill=>'yellow');
#i=5;
$r->createRectangle(76,0,95,19,-fill=>'red');
$r->createRectangle(76,19,95,38,-fill=>'red');
$r->createRectangle(76,38,95,57,-fill=>'red');
$r->createRectangle(76,57,95,76,-fill=>'red');
$r->createRectangle(76,76,95,95,-fill=>'red');
$r->createRectangle(76,95,95,114,-fill=>'red');
$r->createRectangle(76,114,95,133,-fill=>'red');
$r->createRectangle(76,133,95,152,-fill=>'red');
$r->createRectangle(76,152,95,171,-fill=>'yellow');
$r->createRectangle(76,171,95,190,-fill=>'yellow');
$r->createRectangle(76,190,95,209,-fill=>'yellow');
$r->createRectangle(76,209,95,228,-fill=>'yellow');
$r->createRectangle(76,228,95,247,-fill=>'yellow');
$r->createRectangle(76,247,95,266,-fill=>'yellow');
$r->createRectangle(76,266,95,285,-fill=>'yellow');
$r->createRectangle(76,285,95,304,-fill=>'yellow');
$r->createRectangle(76,304,95,323,-fill=>'yellow');
$r->createRectangle(76,323,95,342,-fill=>'yellow');
$r->createRectangle(76,342,95,361,-fill=>'yellow');
$r->createRectangle(76,361,95,380,-fill=>'yellow');
$r->createRectangle(76,380,95,399,-fill=>'yellow');
$r->createRectangle(76,399,95,418,-fill=>'yellow');
$r->createRectangle(76,418,95,437,-fill=>'yellow');
$r->createRectangle(76,437,95,456,-fill=>'yellow');
$r->createRectangle(76,456,95,475,-fill=>'yellow');
$r->createRectangle(76,475,95,494,-fill=>'yellow');
$r->createRectangle(76,494,95,513,-fill=>"#DAA520");
$r->createRectangle(76,513,95,532,-fill=>"#DAA520");
$r->createRectangle(76,532,95,551,-fill=>"#DAA520");
$r->createRectangle(76,551,95,570,-fill=>"#DAA520");
$r->createRectangle(76,570,95,589,-fill=>"#DAA520");
$r->createRectangle(76,589,95,608,-fill=>"#DAA520");
$r->createRectangle(76,608,95,627,-fill=>"#DAA520");
$r->createRectangle(76,627,95,646,-fill=>'yellow');
$r->createRectangle(76,646,95,665,-fill=>'yellow');
$r->createRectangle(76,665,95,684,-fill=>'yellow');
#i=6;
$r->createRectangle(95,0,114,19,-fill=>'red');
$r->createRectangle(95,19,114,38,-fill=>'red');
$r->createRectangle(95,38,114,57,-fill=>'red');
$r->createRectangle(95,57,114,76,-fill=>'red');
$r->createRectangle(95,76,114,95,-fill=>'red');
$r->createRectangle(95,95,114,114,-fill=>'red');
$r->createRectangle(95,114,114,133,-fill=>'red');
$r->createRectangle(95,133,114,152,-fill=>'red');
$r->createRectangle(95,152,114,171,-fill=>'red');
$r->createRectangle(95,171,114,190,-fill=>'yellow');
$r->createRectangle(95,190,114,209,-fill=>'yellow');
$r->createRectangle(95,209,114,228,-fill=>'yellow');
$r->createRectangle(95,228,114,247,-fill=>'yellow');
$r->createRectangle(95,247,114,266,-fill=>'yellow');
$r->createRectangle(95,266,114,285,-fill=>'yellow');
$r->createRectangle(95,285,114,304,-fill=>'yellow');
$r->createRectangle(95,304,114,323,-fill=>'yellow');
$r->createRectangle(95,323,114,342,-fill=>'yellow');
$r->createRectangle(95,342,114,361,-fill=>'red');
$r->createRectangle(95,361,114,380,-fill=>'yellow');
$r->createRectangle(95,380,114,399,-fill=>'yellow');
$r->createRectangle(95,399,114,418,-fill=>'yellow');
$r->createRectangle(95,418,114,437,-fill=>'yellow');
$r->createRectangle(95,437,114,456,-fill=>'yellow');
$r->createRectangle(95,456,114,475,-fill=>'yellow');
$r->createRectangle(95,475,114,494,-fill=>'yellow');
$r->createRectangle(95,494,114,513,-fill=>'yellow');
$r->createRectangle(95,513,114,532,-fill=>'yellow');
$r->createRectangle(95,532,114,551,-fill=>"#DAA520");
$r->createRectangle(95,551,114,570,-fill=>"#DAA520");
$r->createRectangle(95,570,114,589,-fill=>'yellow');
$r->createRectangle(95,589,114,608,-fill=>"#DAA520");
$r->createRectangle(95,608,114,627,-fill=>'yellow');
$r->createRectangle(95,627,114,646,-fill=>'yellow');
$r->createRectangle(95,646,114,665,-fill=>'yellow');
$r->createRectangle(95,665,114,684,-fill=>'yellow');
#i=7;
$r->createRectangle(114,0,133,19,-fill=>'red');
$r->createRectangle(114,19,133,38,-fill=>'red');
$r->createRectangle(114,38,133,57,-fill=>'red');
$r->createRectangle(114,57,133,76,-fill=>'red');
$r->createRectangle(114,76,133,95,-fill=>'red');
$r->createRectangle(114,95,133,114,-fill=>'red');
$r->createRectangle(114,114,133,133,-fill=>'red');
$r->createRectangle(114,133,133,152,-fill=>'red');
$r->createRectangle(114,152,133,171,-fill=>'yellow');
$r->createRectangle(114,171,133,190,-fill=>'yellow');
$r->createRectangle(114,190,133,209,-fill=>'yellow');
$r->createRectangle(114,209,133,228,-fill=>'yellow');
$r->createRectangle(114,228,133,247,-fill=>'yellow');
$r->createRectangle(114,247,133,266,-fill=>'yellow');
$r->createRectangle(114,266,133,285,-fill=>'yellow');
$r->createRectangle(114,285,133,304,-fill=>'yellow');
$r->createRectangle(114,304,133,323,-fill=>'red');
$r->createRectangle(114,323,133,342,-fill=>'red');
$r->createRectangle(114,342,133,361,-fill=>'red');
$r->createRectangle(114,361,133,380,-fill=>'yellow');
$r->createRectangle(114,380,133,399,-fill=>'yellow');
$r->createRectangle(114,399,133,418,-fill=>'yellow');
$r->createRectangle(114,418,133,437,-fill=>'yellow');
$r->createRectangle(114,437,133,456,-fill=>'yellow');
$r->createRectangle(114,456,133,475,-fill=>'yellow');
$r->createRectangle(114,475,133,494,-fill=>'yellow');
$r->createRectangle(114,494,133,513,-fill=>"#DAA520");
$r->createRectangle(114,513,133,532,-fill=>"#DAA520");
$r->createRectangle(114,532,133,551,-fill=>"#DAA520");
$r->createRectangle(114,551,133,570,-fill=>'yellow');
$r->createRectangle(114,570,133,589,-fill=>'yellow');
$r->createRectangle(114,589,133,608,-fill=>'yellow');
$r->createRectangle(114,608,133,627,-fill=>'yellow');
$r->createRectangle(114,627,133,646,-fill=>'yellow');
$r->createRectangle(114,646,133,665,-fill=>'yellow');
$r->createRectangle(114,665,133,684,-fill=>'yellow');
#i=8;
$r->createRectangle(133,0,152,19,-fill=>'red');
$r->createRectangle(133,19,152,38,-fill=>'red');
$r->createRectangle(133,38,152,57,-fill=>'red');
$r->createRectangle(133,57,152,76,-fill=>'red');
$r->createRectangle(133,76,152,95,-fill=>'red');
$r->createRectangle(133,95,152,114,-fill=>'red');
$r->createRectangle(133,114,152,133,-fill=>'red');
$r->createRectangle(133,133,152,152,-fill=>'red');
$r->createRectangle(133,152,152,171,-fill=>'yellow');
$r->createRectangle(133,171,152,190,-fill=>'yellow');
$r->createRectangle(133,190,152,209,-fill=>'yellow');
$r->createRectangle(133,209,152,228,-fill=>'yellow');
$r->createRectangle(133,228,152,247,-fill=>'yellow');
$r->createRectangle(133,247,152,266,-fill=>'yellow');
$r->createRectangle(133,266,152,285,-fill=>'yellow');
$r->createRectangle(133,285,152,304,-fill=>'red');
$r->createRectangle(133,304,152,323,-fill=>'red');
$r->createRectangle(133,323,152,342,-fill=>'red');
$r->createRectangle(133,342,152,361,-fill=>'red');
$r->createRectangle(133,361,152,380,-fill=>'red');
$r->createRectangle(133,380,152,399,-fill=>'red');
$r->createRectangle(133,399,152,418,-fill=>'red');
$r->createRectangle(133,418,152,437,-fill=>'yellow');
$r->createRectangle(133,437,152,456,-fill=>'yellow');
$r->createRectangle(133,456,152,475,-fill=>'yellow');
$r->createRectangle(133,475,152,494,-fill=>'yellow');
$r->createRectangle(133,494,152,513,-fill=>'yellow');
$r->createRectangle(133,513,152,532,-fill=>'yellow');
$r->createRectangle(133,532,152,551,-fill=>"#DAA520");
$r->createRectangle(133,551,152,570,-fill=>'yellow');
$r->createRectangle(133,570,152,589,-fill=>"#DAA520");
$r->createRectangle(133,589,152,608,-fill=>'yellow');
$r->createRectangle(133,608,152,627,-fill=>'yellow');
$r->createRectangle(133,627,152,646,-fill=>'yellow');
$r->createRectangle(133,646,152,665,-fill=>'yellow');
$r->createRectangle(133,665,152,684,-fill=>'yellow');
#i=9;
$r->createRectangle(152,0,171,19,-fill=>'red');
$r->createRectangle(152,19,171,38,-fill=>'red');
$r->createRectangle(152,38,171,57,-fill=>'red');
$r->createRectangle(152,57,171,76,-fill=>'red');
$r->createRectangle(152,76,171,95,-fill=>'red');
$r->createRectangle(152,95,171,114,-fill=>'red');
$r->createRectangle(152,114,171,133,-fill=>'red');
$r->createRectangle(152,133,171,152,-fill=>'red');
$r->createRectangle(152,152,171,171,-fill=>'red');
$r->createRectangle(152,171,171,190,-fill=>'yellow');
$r->createRectangle(152,190,171,209,-fill=>'yellow');
$r->createRectangle(152,209,171,228,-fill=>'yellow');
$r->createRectangle(152,228,171,247,-fill=>'yellow');
$r->createRectangle(152,247,171,266,-fill=>'yellow');
$r->createRectangle(152,266,171,285,-fill=>'yellow');
$r->createRectangle(152,285,171,304,-fill=>'yellow');
$r->createRectangle(152,304,171,323,-fill=>'red');
$r->createRectangle(152,323,171,342,-fill=>'red');
$r->createRectangle(152,342,171,361,-fill=>'red');
$r->createRectangle(152,361,171,380,-fill=>'red');
$r->createRectangle(152,380,171,399,-fill=>'red');
$r->createRectangle(152,399,171,418,-fill=>'red');
$r->createRectangle(152,418,171,437,-fill=>'red');
$r->createRectangle(152,437,171,456,-fill=>'yellow');
$r->createRectangle(152,456,171,475,-fill=>'yellow');
$r->createRectangle(152,475,171,494,-fill=>'yellow');
$r->createRectangle(152,494,171,513,-fill=>'yellow');
$r->createRectangle(152,513,171,532,-fill=>'yellow');
$r->createRectangle(152,532,171,551,-fill=>"#DAA520");
$r->createRectangle(152,551,171,570,-fill=>'yellow');
$r->createRectangle(152,570,171,589,-fill=>"#DAA520");
$r->createRectangle(152,589,171,608,-fill=>'yellow');
$r->createRectangle(152,608,171,627,-fill=>'yellow');
$r->createRectangle(152,627,171,646,-fill=>'yellow');
$r->createRectangle(152,646,171,665,-fill=>'yellow');
$r->createRectangle(152,665,171,684,-fill=>'yellow');
#i=10;
$r->createRectangle(171,0,190,19,-fill=>'red');
$r->createRectangle(171,19,190,38,-fill=>'red');
$r->createRectangle(171,38,190,57,-fill=>'red');
$r->createRectangle(171,57,190,76,-fill=>'red');
$r->createRectangle(171,76,190,95,-fill=>'red');
$r->createRectangle(171,95,190,114,-fill=>'red');
$r->createRectangle(171,114,190,133,-fill=>'red');
$r->createRectangle(171,133,190,152,-fill=>'red');
$r->createRectangle(171,152,190,171,-fill=>'yellow');
$r->createRectangle(171,171,190,190,-fill=>'yellow');
$r->createRectangle(171,190,190,209,-fill=>'yellow');
$r->createRectangle(171,209,190,228,-fill=>'yellow');
$r->createRectangle(171,228,190,247,-fill=>'yellow');
$r->createRectangle(171,247,190,266,-fill=>'yellow');
$r->createRectangle(171,266,190,285,-fill=>'yellow');
$r->createRectangle(171,285,190,304,-fill=>'yellow');
$r->createRectangle(171,304,190,323,-fill=>'red');
$r->createRectangle(171,323,190,342,-fill=>'red');
$r->createRectangle(171,342,190,361,-fill=>'red');
$r->createRectangle(171,361,190,380,-fill=>'red');
$r->createRectangle(171,380,190,399,-fill=>'red');
$r->createRectangle(171,399,190,418,-fill=>'red');
$r->createRectangle(171,418,190,437,-fill=>'red');
$r->createRectangle(171,437,190,456,-fill=>'red');
$r->createRectangle(171,456,190,475,-fill=>'yellow');
$r->createRectangle(171,475,190,494,-fill=>'yellow');
$r->createRectangle(171,494,190,513,-fill=>'yellow');
$r->createRectangle(171,513,190,532,-fill=>'yellow');
$r->createRectangle(171,532,190,551,-fill=>"#DAA520");
$r->createRectangle(171,551,190,570,-fill=>"#DAA520");
$r->createRectangle(171,570,190,589,-fill=>"#DAA520");
$r->createRectangle(171,589,190,608,-fill=>'yellow');
$r->createRectangle(171,608,190,627,-fill=>'yellow');
$r->createRectangle(171,627,190,646,-fill=>'yellow');
$r->createRectangle(171,646,190,665,-fill=>'yellow');
$r->createRectangle(171,665,190,684,-fill=>'yellow');
#i=11;
$r->createRectangle(190,0,209,19,-fill=>'red');
$r->createRectangle(190,19,209,38,-fill=>'red');
$r->createRectangle(190,38,209,57,-fill=>'red');
$r->createRectangle(190,57,209,76,-fill=>'red');
$r->createRectangle(190,76,209,95,-fill=>'red');
$r->createRectangle(190,95,209,114,-fill=>'red');
$r->createRectangle(190,114,209,133,-fill=>'red');
$r->createRectangle(190,133,209,152,-fill=>'red');
$r->createRectangle(190,152,209,171,-fill=>'yellow');
$r->createRectangle(190,171,209,190,-fill=>'yellow');
$r->createRectangle(190,190,209,209,-fill=>'yellow');
$r->createRectangle(190,209,209,228,-fill=>'yellow');
$r->createRectangle(190,228,209,247,-fill=>'yellow');
$r->createRectangle(190,247,209,266,-fill=>'yellow');
$r->createRectangle(190,266,209,285,-fill=>'yellow');
$r->createRectangle(190,285,209,304,-fill=>'yellow');
$r->createRectangle(190,304,209,323,-fill=>'yellow');
$r->createRectangle(190,323,209,342,-fill=>'red');
$r->createRectangle(190,342,209,361,-fill=>'red');
$r->createRectangle(190,361,209,380,-fill=>'red');
$r->createRectangle(190,380,209,399,-fill=>'red');
$r->createRectangle(190,399,209,418,-fill=>'red');
$r->createRectangle(190,418,209,437,-fill=>'red');
$r->createRectangle(190,437,209,456,-fill=>'red');
$r->createRectangle(190,456,209,475,-fill=>'yellow');
$r->createRectangle(190,475,209,494,-fill=>'yellow');
$r->createRectangle(190,494,209,513,-fill=>'yellow');
$r->createRectangle(190,513,209,532,-fill=>'yellow');
$r->createRectangle(190,532,209,551,-fill=>"#DAA520");
$r->createRectangle(190,551,209,570,-fill=>"#DAA520");
$r->createRectangle(190,570,209,589,-fill=>"#DAA520");
$r->createRectangle(190,589,209,608,-fill=>"#DAA520");
$r->createRectangle(190,608,209,627,-fill=>"#DAA520");
$r->createRectangle(190,627,209,646,-fill=>'yellow');
$r->createRectangle(190,646,209,665,-fill=>'yellow');
$r->createRectangle(190,665,209,684,-fill=>'yellow');
#i=12;
$r->createRectangle(209,0,228,19,-fill=>'yellow');
$r->createRectangle(209,19,228,38,-fill=>'red');
$r->createRectangle(209,38,228,57,-fill=>'red');
$r->createRectangle(209,57,228,76,-fill=>'red');
$r->createRectangle(209,76,228,95,-fill=>'red');
$r->createRectangle(209,95,228,114,-fill=>'red');
$r->createRectangle(209,114,228,133,-fill=>'red');
$r->createRectangle(209,133,228,152,-fill=>'yellow');
$r->createRectangle(209,152,228,171,-fill=>'yellow');
$r->createRectangle(209,171,228,190,-fill=>'yellow');
$r->createRectangle(209,190,228,209,-fill=>'yellow');
$r->createRectangle(209,209,228,228,-fill=>'yellow');
$r->createRectangle(209,228,228,247,-fill=>'yellow');
$r->createRectangle(209,247,228,266,-fill=>'yellow');
$r->createRectangle(209,266,228,285,-fill=>'yellow');
$r->createRectangle(209,285,228,304,-fill=>'yellow');
$r->createRectangle(209,304,228,323,-fill=>'yellow');
$r->createRectangle(209,323,228,342,-fill=>'yellow');
$r->createRectangle(209,342,228,361,-fill=>'red');
$r->createRectangle(209,361,228,380,-fill=>'red');
$r->createRectangle(209,380,228,399,-fill=>'red');
$r->createRectangle(209,399,228,418,-fill=>'red');
$r->createRectangle(209,418,228,437,-fill=>'red');
$r->createRectangle(209,437,228,456,-fill=>'red');
$r->createRectangle(209,456,228,475,-fill=>'red');
$r->createRectangle(209,475,228,494,-fill=>'yellow');
$r->createRectangle(209,494,228,513,-fill=>'yellow');
$r->createRectangle(209,513,228,532,-fill=>'yellow');
$r->createRectangle(209,532,228,551,-fill=>'yellow');
$r->createRectangle(209,551,228,570,-fill=>"#DAA520");
$r->createRectangle(209,570,228,589,-fill=>"#DAA520");
$r->createRectangle(209,589,228,608,-fill=>"#DAA520");
$r->createRectangle(209,608,228,627,-fill=>"#DAA520");
$r->createRectangle(209,627,228,646,-fill=>"#DAA520");
$r->createRectangle(209,646,228,665,-fill=>'yellow');
$r->createRectangle(209,665,228,684,-fill=>'yellow');
#i=13;
$r->createRectangle(228,0,247,19,-fill=>'yellow');
$r->createRectangle(228,19,247,38,-fill=>'yellow');
$r->createRectangle(228,38,247,57,-fill=>'yellow');
$r->createRectangle(228,57,247,76,-fill=>'red');
$r->createRectangle(228,76,247,95,-fill=>'red');
$r->createRectangle(228,95,247,114,-fill=>'red');
$r->createRectangle(228,114,247,133,-fill=>'yellow');
$r->createRectangle(228,133,247,152,-fill=>'yellow');
$r->createRectangle(228,152,247,171,-fill=>'yellow');
$r->createRectangle(228,171,247,190,-fill=>'yellow');
$r->createRectangle(228,190,247,209,-fill=>"#DAA520");
$r->createRectangle(228,209,247,228,-fill=>'yellow');
$r->createRectangle(228,228,247,247,-fill=>'yellow');
$r->createRectangle(228,247,247,266,-fill=>"#DAA520");
$r->createRectangle(228,266,247,285,-fill=>"#DAA520");
$r->createRectangle(228,285,247,304,-fill=>'yellow');
$r->createRectangle(228,304,247,323,-fill=>'yellow');
$r->createRectangle(228,323,247,342,-fill=>'yellow');
$r->createRectangle(228,342,247,361,-fill=>'yellow');
$r->createRectangle(228,361,247,380,-fill=>'red');
$r->createRectangle(228,380,247,399,-fill=>'red');
$r->createRectangle(228,399,247,418,-fill=>'red');
$r->createRectangle(228,418,247,437,-fill=>'red');
$r->createRectangle(228,437,247,456,-fill=>'red');
$r->createRectangle(228,456,247,475,-fill=>'red');
$r->createRectangle(228,475,247,494,-fill=>'yellow');
$r->createRectangle(228,494,247,513,-fill=>'yellow');
$r->createRectangle(228,513,247,532,-fill=>'yellow');
$r->createRectangle(228,532,247,551,-fill=>"#DAA520");
$r->createRectangle(228,551,247,570,-fill=>"#DAA520");
$r->createRectangle(228,570,247,589,-fill=>"#DAA520");
$r->createRectangle(228,589,247,608,-fill=>"#DAA520");
$r->createRectangle(228,608,247,627,-fill=>"#DAA520");
$r->createRectangle(228,627,247,646,,-fill=>"#DAA520");
$r->createRectangle(228,646,247,665,-fill=>'yellow');
$r->createRectangle(228,665,247,684,-fill=>'yellow');
#i=14;
$r->createRectangle(247,0,266,19,-fill=>'yellow');
$r->createRectangle(247,19,266,38,-fill=>'yellow');
$r->createRectangle(247,38,266,57,-fill=>'yellow');
$r->createRectangle(247,57,266,76,-fill=>'yellow');
$r->createRectangle(247,76,266,95,-fill=>'red');
$r->createRectangle(247,95,266,114,-fill=>'yellow');
$r->createRectangle(247,114,266,133,-fill=>'yellow');
$r->createRectangle(247,133,266,152,-fill=>'yellow');  
$r->createRectangle(247,152,266,171,-fill=>'yellow');  
$r->createRectangle(247,171,266,190,-fill=>'yellow');  
$r->createRectangle(247,190,266,209,-fill=>"#DAA520");  
$r->createRectangle(247,209,266,228,-fill=>"#DAA520");  
$r->createRectangle(247,228,266,247,-fill=>"#DAA520");  
$r->createRectangle(247,247,266,266,-fill=>"#DAA520");  
$r->createRectangle(247,266,266,285,-fill=>"#DAA520");  
$r->createRectangle(247,285,266,304,-fill=>"#DAA520");  
$r->createRectangle(247,304,266,323,-fill=>"#DAA520");  
$r->createRectangle(247,323,266,342,-fill=>'yellow');  
$r->createRectangle(247,342,266,361,-fill=>'yellow');
$r->createRectangle(247,361,266,380,-fill=>'yellow');
$r->createRectangle(247,380,266,399,-fill=>'red');
$r->createRectangle(247,399,266,418,-fill=>'red');
$r->createRectangle(247,418,266,437,-fill=>'red');
$r->createRectangle(247,437,266,456,-fill=>'red');
$r->createRectangle(247,456,266,475,-fill=>'red');
$r->createRectangle(247,475,266,494,-fill=>'yellow');
$r->createRectangle(247,494,266,513,-fill=>'yellow');
$r->createRectangle(247,513,266,532,-fill=>'yellow');
$r->createRectangle(247,532,266,551,-fill=>"#DAA520");
$r->createRectangle(247,551,266,570,-fill=>"#DAA520");
$r->createRectangle(247,570,266,589,-fill=>"#DAA520");
$r->createRectangle(247,589,266,608,-fill=>"#DAA520");
$r->createRectangle(247,608,266,627,-fill=>"#DAA520");
$r->createRectangle(247,627,266,646,-fill=>"#DAA520");
$r->createRectangle(247,646,266,665,-fill=>"#DAA520");
$r->createRectangle(247,665,266,684,-fill=>"#DAA520");
#i=15;
$r->createRectangle(266,0,285,19,-fill=>"#DAA520");
$r->createRectangle(266,19,285,38,-fill=>'yellow');
$r->createRectangle(266,38,285,57,-fill=>'yellow');
$r->createRectangle(266,57,285,76,-fill=>'yellow');
$r->createRectangle(266,76,285,95,-fill=>'yellow');
$r->createRectangle(266,95,285,114,-fill=>'yellow');
$r->createRectangle(266,114,285,133,-fill=>'yellow');
$r->createRectangle(266,133,285,152,-fill=>'yellow');
$r->createRectangle(266,152,285,171,-fill=>'yellow');
$r->createRectangle(266,171,285,190,-fill=>"#DAA520");
$r->createRectangle(266,190,285,209,-fill=>"#DAA520");
$r->createRectangle(266,209,285,228,-fill=>"#DAA520");
$r->createRectangle(266,228,285,247,-fill=>"#DAA520");
$r->createRectangle(266,247,285,266,-fill=>"#DAA520");
$r->createRectangle(266,266,285,285,-fill=>"#DAA520");
$r->createRectangle(266,285,285,304,-fill=>"#DAA520");
$r->createRectangle(266,304,285,323,-fill=>"#DAA520");
$r->createRectangle(266,323,285,342,-fill=>"#DAA520");
$r->createRectangle(266,342,285,361,-fill=>'yellow');
$r->createRectangle(266,361,285,380,-fill=>'yellow');
$r->createRectangle(266,380,285,399,-fill=>'yellow');
$r->createRectangle(266,399,285,418,-fill=>'yellow');
$r->createRectangle(266,418,285,437,-fill=>'red');
$r->createRectangle(266,437,285,456,-fill=>'red');
$r->createRectangle(266,456,285,475,-fill=>'red');
$r->createRectangle(266,475,285,494,-fill=>'yellow');
$r->createRectangle(266,494,285,513,-fill=>'yellow');
$r->createRectangle(266,513,285,532,-fill=>'yellow');
$r->createRectangle(266,532,285,551,-fill=>"#DAA520");
$r->createRectangle(266,551,285,570,-fill=>"#DAA520");
$r->createRectangle(266,570,285,589,-fill=>'white');
$r->createRectangle(266,589,285,608,-fill=>'white');
$r->createRectangle(266,608,285,627,-fill=>"#DAA520");
$r->createRectangle(266,627,285,646,-fill=>"#DAA520");
$r->createRectangle(266,646,285,665,-fill=>"#DAA520");
$r->createRectangle(266,665,285,684,-fill=>"#DAA520");
#i=16;
$r->createRectangle(285,0,304,19,-fill=>"#DAA520");
$r->createRectangle(285,19,304,38,-fill=>"#DAA520");
$r->createRectangle(285,38,304,57,-fill=>"#DAA520");
$r->createRectangle(285,57,304,76,-fill=>'yellow');
$r->createRectangle(285,76,304,95,-fill=>'yellow');
$r->createRectangle(285,95,304,114,-fill=>'yellow');
$r->createRectangle(285,114,304,133,-fill=>'yellow');
$r->createRectangle(285,133,304,152,-fill=>'yellow');
$r->createRectangle(285,152,304,171,-fill=>'yellow');
$r->createRectangle(285,171,304,190,-fill=>"#DAA520");
$r->createRectangle(285,190,304,209,-fill=>"#DAA520");
$r->createRectangle(285,209,304,228,-fill=>'white');
$r->createRectangle(285,228,304,247,-fill=>'white');
$r->createRectangle(285,247,304,266,-fill=>'white');
$r->createRectangle(285,266,304,285,-fill=>'white');
$r->createRectangle(285,285,304,304,-fill=>"#DAA520");
$r->createRectangle(285,304,304,323,-fill=>"#DAA520");
$r->createRectangle(285,323,304,342,-fill=>"#DAA520");
$r->createRectangle(285,342,304,361,-fill=>"#DAA520");
$r->createRectangle(285,361,304,380,-fill=>"#DAA520");
$r->createRectangle(285,380,304,399,-fill=>'yellow');
$r->createRectangle(285,399,304,418,-fill=>'yellow');
$r->createRectangle(285,418,304,437,-fill=>'yellow');
$r->createRectangle(285,437,304,456,-fill=>'yellow');
$r->createRectangle(285,456,304,475,-fill=>'yellow');
$r->createRectangle(285,475,304,494,-fill=>'yellow');
$r->createRectangle(285,494,304,513,-fill=>'yellow');
$r->createRectangle(285,513,304,532,-fill=>"#DAA520");
$r->createRectangle(285,532,304,551,-fill=>"#DAA520");
$r->createRectangle(285,551,304,570,-fill=>"#DAA520");
$r->createRectangle(285,570,304,589,-fill=>'white');
$r->createRectangle(285,589,304,608,-fill=>'white');
$r->createRectangle(285,608,304,627,-fill=>'white');
$r->createRectangle(285,627,304,646,-fill=>'white');
$r->createRectangle(285,646,304,665,-fill=>'white');
$r->createRectangle(285,665,304,684,-fill=>'white');
#i=17;
$r->createRectangle(304,0,323,19,-fill=>'white');
$r->createRectangle(304,19,323,38,-fill=>"#DAA520");
$r->createRectangle(304,38,323,57,-fill=>"#DAA520");
$r->createRectangle(304,57,323,76,-fill=>'yellow');
$r->createRectangle(304,76,323,95,-fill=>"#DAA520");
$r->createRectangle(304,95,323,114,-fill=>"#DAA520");
$r->createRectangle(304,114,323,133,-fill=>"#DAA520");
$r->createRectangle(304,133,323,152,-fill=>'yellow');
$r->createRectangle(304,152,323,171,-fill=>'yellow');
$r->createRectangle(304,171,323,190,-fill=>"#DAA520");
$r->createRectangle(304,190,323,209,-fill=>"#DAA520");
$r->createRectangle(304,209,323,228,-fill=>'white');
$r->createRectangle(304,228,323,247,-fill=>'white');
$r->createRectangle(304,247,323,266,-fill=>'white');
$r->createRectangle(304,266,323,285,-fill=>'white');
$r->createRectangle(304,285,323,304,-fill=>'white');
$r->createRectangle(304,304,323,323,-fill=>"#DAA520");
$r->createRectangle(304,323,323,342,-fill=>"#DAA520");
$r->createRectangle(304,342,323,361,-fill=>"#DAA520");
$r->createRectangle(304,361,323,380,-fill=>"#DAA520");
$r->createRectangle(304,380,323,399,-fill=>"#DAA520");
$r->createRectangle(304,399,323,418,-fill=>'yellow');
$r->createRectangle(304,418,323,437,-fill=>'yellow');
$r->createRectangle(304,437,323,456,-fill=>'yellow');
$r->createRectangle(304,456,323,475,-fill=>'yellow');
$r->createRectangle(304,475,323,494,-fill=>'yellow');
$r->createRectangle(304,494,323,513,-fill=>'yellow');
$r->createRectangle(304,513,323,532,-fill=>"#DAA520");
$r->createRectangle(304,532,323,551,-fill=>"#DAA520");
$r->createRectangle(304,551,323,570,-fill=>"#DAA520");
$r->createRectangle(304,570,323,589,-fill=>'white');
$r->createRectangle(304,589,323,608,-fill=>'white');
$r->createRectangle(304,608,323,627,-fill=>'white');
$r->createRectangle(304,627,323,646,-fill=>'white');
$r->createRectangle(304,646,323,665,-fill=>'white');
$r->createRectangle(304,665,323,684,-fill=>'white');
#i=18;
$r->createRectangle(323,0,342,19,-fill=>'white');
$r->createRectangle(323,19,342,38,-fill=>'white');
$r->createRectangle(323,38,342,57,-fill=>"#DAA520");
$r->createRectangle(323,57,342,76,-fill=>"#DAA520");
$r->createRectangle(323,76,342,95,-fill=>"#DAA520");
$r->createRectangle(323,95,342,114,-fill=>"#DAA520");
$r->createRectangle(323,114,342,133,-fill=>"#DAA520");
$r->createRectangle(323,133,342,152,-fill=>"#DAA520");
$r->createRectangle(323,152,342,171,-fill=>"#DAA520");
$r->createRectangle(323,171,342,190,-fill=>"#DAA520");
$r->createRectangle(323,190,342,209,-fill=>"#DAA520");
$r->createRectangle(323,209,342,228,-fill=>'white');
$r->createRectangle(323,228,342,247,-fill=>'white');
$r->createRectangle(323,247,342,266,-fill=>'white');
$r->createRectangle(323,266,342,285,-fill=>'white');
$r->createRectangle(323,285,342,304,-fill=>'white');
$r->createRectangle(323,304,342,323,-fill=>'white');
$r->createRectangle(323,323,342,342,-fill=>'white');
$r->createRectangle(323,342,342,361,-fill=>'white');
$r->createRectangle(323,361,342,380,-fill=>"#DAA520");
$r->createRectangle(323,380,342,399,-fill=>"#DAA520");
$r->createRectangle(323,399,342,418,-fill=>"#DAA520");
$r->createRectangle(323,418,342,437,-fill=>"#DAA520");
$r->createRectangle(323,437,342,456,-fill=>"#DAA520");
$r->createRectangle(323,456,342,475,-fill=>"#DAA520");
$r->createRectangle(323,475,342,494,-fill=>'yellow');
$r->createRectangle(323,494,342,513,-fill=>"#DAA520");
$r->createRectangle(323,513,342,532,-fill=>"#DAA520");
$r->createRectangle(323,532,342,551,-fill=>"#DAA520");
$r->createRectangle(323,551,342,570,-fill=>'white');
$r->createRectangle(323,570,342,589,-fill=>'white');
$r->createRectangle(323,589,342,608,-fill=>'white');
$r->createRectangle(323,608,342,627,-fill=>'white');
$r->createRectangle(323,627,342,646,-fill=>'white');
$r->createRectangle(323,646,342,665,-fill=>'white');
$r->createRectangle(323,665,342,684,-fill=>'white');
#i=19;
$r->createRectangle(342,0,361,19,-fill=>'white');
$r->createRectangle(342,19,361,38,-fill=>'white');
$r->createRectangle(342,38,361,57,-fill=>"#DAA520");
$r->createRectangle(342,57,361,76,-fill=>"#DAA520");
$r->createRectangle(342,76,361,95,-fill=>"#DAA520");
$r->createRectangle(342,95,361,114,-fill=>"#DAA520");
$r->createRectangle(342,114,361,133,-fill=>"#DAA520");
$r->createRectangle(342,133,361,152,-fill=>"#DAA520");
$r->createRectangle(342,152,361,171,-fill=>"#DAA520");
$r->createRectangle(342,171,361,190,-fill=>"#DAA520");
$r->createRectangle(342,190,361,209,-fill=>"#DAA520");
$r->createRectangle(342,209,361,228,-fill=>'white');
$r->createRectangle(342,228,361,247,-fill=>'white');
$r->createRectangle(342,247,361,266,-fill=>'white');
$r->createRectangle(342,266,361,285,-fill=>'white');
$r->createRectangle(342,285,361,304,-fill=>'white');
$r->createRectangle(342,304,361,323,-fill=>'white');
$r->createRectangle(342,323,361,342,-fill=>'white');
$r->createRectangle(342,342,361,361,-fill=>'white');
$r->createRectangle(342,361,361,380,-fill=>"#DAA520");
$r->createRectangle(342,380,361,399,-fill=>"#DAA520");
$r->createRectangle(342,399,361,418,-fill=>"#DAA520");
$r->createRectangle(342,418,361,437,-fill=>"#DAA520");
$r->createRectangle(342,437,361,456,-fill=>"#DAA520");
$r->createRectangle(342,456,361,475,-fill=>"#DAA520");
$r->createRectangle(342,475,361,494,-fill=>'yellow');
$r->createRectangle(342,494,361,513,-fill=>"#DAA520");
$r->createRectangle(342,513,361,532,-fill=>"#DAA520");
$r->createRectangle(342,532,361,551,-fill=>"#DAA520");
$r->createRectangle(342,551,361,570,-fill=>'white');
$r->createRectangle(342,570,361,589,-fill=>'white');
$r->createRectangle(342,589,361,608,-fill=>'white');
$r->createRectangle(342,608,361,627,-fill=>'white');
$r->createRectangle(342,627,361,646,-fill=>'white');
$r->createRectangle(342,646,361,665,-fill=>'white');
$r->createRectangle(342,665,361,684,-fill=>'white');
#i=20;
$r->createRectangle(361,0,380,19,-fill=>'white');
$r->createRectangle(361,19,380,38,-fill=>'white');
$r->createRectangle(361,38,380,57,-fill=>'white');
$r->createRectangle(361,57,380,76,-fill=>'white');
$r->createRectangle(361,76,380,95,-fill=>'white');
$r->createRectangle(361,95,380,114,-fill=>'white');
$r->createRectangle(361,114,380,133,-fill=>'white');
$r->createRectangle(361,133,380,152,-fill=>"#DAA520");
$r->createRectangle(361,152,380,171,-fill=>"#DAA520");
$r->createRectangle(361,171,380,190,-fill=>"#DAA520");
$r->createRectangle(361,190,380,209,-fill=>"#DAA520");
$r->createRectangle(361,209,380,228,-fill=>"#DAA520");
$r->createRectangle(361,228,380,247,-fill=>"#DAA520");
$r->createRectangle(361,247,380,266,-fill=>"#DAA520");
$r->createRectangle(361,266,380,285,-fill=>"#DAA520");
$r->createRectangle(361,285,380,304,-fill=>"#DAA520");
$r->createRectangle(361,304,380,323,-fill=>'white');
$r->createRectangle(361,323,380,342,-fill=>'white');
$r->createRectangle(361,342,380,361,-fill=>'white');
$r->createRectangle(361,361,380,380,-fill=>'white');
$r->createRectangle(361,380,380,399,-fill=>'white');
$r->createRectangle(361,399,380,418,-fill=>"#DAA520");
$r->createRectangle(361,418,380,437,-fill=>"#DAA520");
$r->createRectangle(361,437,380,456,-fill=>"#DAA520");
$r->createRectangle(361,456,380,475,-fill=>"#DAA520");
$r->createRectangle(361,475,380,494,-fill=>"#DAA520");
$r->createRectangle(361,494,380,513,-fill=>"#DAA520");
$r->createRectangle(361,513,380,532,-fill=>"#DAA520");
$r->createRectangle(361,532,380,551,-fill=>"#DAA520");
$r->createRectangle(361,551,380,570,-fill=>'white');
$r->createRectangle(361,570,380,589,-fill=>'white');
$r->createRectangle(361,589,380,608,-fill=>'white');
$r->createRectangle(361,608,380,627,-fill=>'white');
$r->createRectangle(361,627,380,646,-fill=>'white');
$r->createRectangle(361,646,380,665,-fill=>'white');
$r->createRectangle(361,665,380,684,-fill=>'white');
#i=21;
$r->createRectangle(380,0,399,19,-fill=>"#DAA520");
$r->createRectangle(380,19,399,38,-fill=>'white');
$r->createRectangle(380,38,399,57,-fill=>'white');
$r->createRectangle(380,57,399,76,-fill=>'white');
$r->createRectangle(380,76,399,95,-fill=>'white');
$r->createRectangle(380,95,399,114,-fill=>'white');
$r->createRectangle(380,114,399,133,-fill=>'white');
$r->createRectangle(380,133,399,152,-fill=>"#DAA520");
$r->createRectangle(380,152,399,171,-fill=>"#DAA520");
$r->createRectangle(380,171,399,190,-fill=>"#DAA520");
$r->createRectangle(380,190,399,209,-fill=>"#DAA520");
$r->createRectangle(380,209,399,228,-fill=>"#DAA520");
$r->createRectangle(380,228,399,247,-fill=>"#DAA520");
$r->createRectangle(380,247,399,266,-fill=>"#DAA520");
$r->createRectangle(380,266,399,285,-fill=>"#DAA520");
$r->createRectangle(380,285,399,304,-fill=>"#DAA520");
$r->createRectangle(380,304,399,323,-fill=>"#DAA520");
$r->createRectangle(380,323,399,342,-fill=>"#DAA520");
$r->createRectangle(380,342,399,361,-fill=>"#DAA520");
$r->createRectangle(380,361,399,380,-fill=>"#DAA520");
$r->createRectangle(380,380,399,399,-fill=>"#DAA520");
$r->createRectangle(380,399,399,418,-fill=>'white');
$r->createRectangle(380,418,399,437,-fill=>'white');
$r->createRectangle(380,437,399,456,-fill=>"#DAA520");
$r->createRectangle(380,456,399,475,-fill=>"#DAA520");
$r->createRectangle(380,475,399,494,-fill=>"#DAA520");
$r->createRectangle(380,494,399,513,-fill=>"#DAA520");
$r->createRectangle(380,513,399,532,-fill=>"#DAA520");
$r->createRectangle(380,532,399,551,-fill=>'white');
$r->createRectangle(380,551,399,570,-fill=>'white');
$r->createRectangle(380,570,399,589,-fill=>'white');
$r->createRectangle(380,589,399,608,-fill=>'white');
$r->createRectangle(380,608,399,627,-fill=>'white');
$r->createRectangle(380,627,399,646,-fill=>'white');
$r->createRectangle(380,646,399,665,-fill=>'white');
$r->createRectangle(380,665,399,684,-fill=>'white');
#i=22;
$r->createRectangle(399,0,418,19,-fill=>"#DAA520");
$r->createRectangle(399,19,418,38,-fill=>'white');
$r->createRectangle(399,38,418,57,-fill=>'white');
$r->createRectangle(399,57,418,76,-fill=>'white');
$r->createRectangle(399,76,418,95,-fill=>'white');
$r->createRectangle(399,95,418,114,-fill=>'white');
$r->createRectangle(399,114,418,133,-fill=>'white');
$r->createRectangle(399,133,418,152,-fill=>"#DAA520");
$r->createRectangle(399,152,418,171,-fill=>"#DAA520");
$r->createRectangle(399,171,418,190,-fill=>'yellow');
$r->createRectangle(399,190,418,209,-fill=>'yellow');
$r->createRectangle(399,209,418,228,-fill=>"#DAA520");
$r->createRectangle(399,228,418,247,-fill=>'yellow');
$r->createRectangle(399,247,418,266,-fill=>'yellow');
$r->createRectangle(399,266,418,285,-fill=>"#DAA520");
$r->createRectangle(399,285,418,304,-fill=>"#DAA520");
$r->createRectangle(399,304,418,323,-fill=>"#DAA520");
$r->createRectangle(399,323,418,342,-fill=>"#DAA520");
$r->createRectangle(399,342,418,361,-fill=>"#DAA520");
$r->createRectangle(399,361,418,380,-fill=>"#DAA520");
$r->createRectangle(399,380,418,399,-fill=>"#DAA520");
$r->createRectangle(399,399,418,418,-fill=>'white');
$r->createRectangle(399,418,418,437,-fill=>'white');
$r->createRectangle(399,437,418,456,-fill=>'white');
$r->createRectangle(399,456,418,475,-fill=>'white');
$r->createRectangle(399,475,418,494,-fill=>'white');
$r->createRectangle(399,494,418,513,-fill=>'white');
$r->createRectangle(399,513,418,532,-fill=>'white');
$r->createRectangle(399,532,418,551,-fill=>'white');
$r->createRectangle(399,551,418,579,-fill=>"#DAA520");
$r->createRectangle(399,570,418,589,-fill=>"#DAA520");
$r->createRectangle(399,589,418,608,-fill=>"#DAA520");
$r->createRectangle(399,608,418,627,-fill=>"#DAA520");
$r->createRectangle(399,627,418,646,-fill=>"#DAA520");
$r->createRectangle(399,646,418,665,-fill=>"#DAA520");
$r->createRectangle(399,665,418,684,-fill=>"#DAA520");
#i=23;
$r->createRectangle(418,0,437,19,-fill=>"#DAA520");
$r->createRectangle(418,19,437,38,-fill=>'white');
$r->createRectangle(418,38,437,57,-fill=>'white');
$r->createRectangle(418,57,437,76,-fill=>'white');
$r->createRectangle(418,76,437,95,-fill=>'white');
$r->createRectangle(418,95,437,114,-fill=>'white');
$r->createRectangle(418,114,437,133,-fill=>"#DAA520");
$r->createRectangle(418,133,437,152,-fill=>"#DAA520");
$r->createRectangle(418,152,437,171,-fill=>"#DAA520");
$r->createRectangle(418,171,437,190,-fill=>'yellow');
$r->createRectangle(418,190,437,209,-fill=>'yellow');
$r->createRectangle(418,209,437,228,-fill=>'yellow');
$r->createRectangle(418,228,437,247,-fill=>'yellow');
$r->createRectangle(418,247,437,266,-fill=>'yellow');
$r->createRectangle(418,266,437,285,-fill=>'yellow');
$r->createRectangle(418,285,437,304,-fill=>'yellow');
$r->createRectangle(418,304,437,323,-fill=>"#DAA520");
$r->createRectangle(418,323,437,342,-fill=>"#DAA520");
$r->createRectangle(418,342,437,361,-fill=>"#DAA520");
$r->createRectangle(418,361,437,380,-fill=>"#DAA520");
$r->createRectangle(418,380,437,399,-fill=>"#DAA520");
$r->createRectangle(418,399,437,418,-fill=>'white');
$r->createRectangle(418,418,437,437,-fill=>'white');
$r->createRectangle(418,437,437,456,-fill=>'white');
$r->createRectangle(418,456,437,475,-fill=>'white');
$r->createRectangle(418,475,437,494,-fill=>'white');
$r->createRectangle(418,494,437,513,-fill=>'white');
$r->createRectangle(418,513,437,532,-fill=>'white');
$r->createRectangle(418,532,437,551,-fill=>'white');
$r->createRectangle(418,551,437,570,-fill=>'white');
$r->createRectangle(418,570,437,589,-fill=>"#DAA520");
$r->createRectangle(418,589,437,608,-fill=>"#DAA520");
$r->createRectangle(418,608,437,627,-fill=>"#DAA520");
$r->createRectangle(418,627,437,646,-fill=>"#DAA520");
$r->createRectangle(418,646,437,665,-fill=>"#DAA520");
$r->createRectangle(418,665,437,684,-fill=>"#DAA520");
#i=24;
$r->createRectangle(437,0,456,19,-fill=>"#DAA520");
$r->createRectangle(437,19,456,38,-fill=>'white');
$r->createRectangle(437,38,456,57,-fill=>'white');
$r->createRectangle(437,57,456,76,-fill=>'white');
$r->createRectangle(437,76,456,95,-fill=>'white');
$r->createRectangle(437,95,456,114,-fill=>'white');
$r->createRectangle(437,114,456,133,-fill=>"#DAA520");
$r->createRectangle(437,133,456,152,-fill=>"#DAA520");
$r->createRectangle(437,152,456,171,-fill=>"#DAA520");
$r->createRectangle(437,171,456,190,-fill=>'yellow');
$r->createRectangle(437,190,456,209,-fill=>'yellow');
$r->createRectangle(437,209,456,228,-fill=>'yellow');
$r->createRectangle(437,228,456,247,-fill=>'yellow');
$r->createRectangle(437,247,456,266,-fill=>'red');
$r->createRectangle(437,266,456,285,-fill=>'red');
$r->createRectangle(437,285,456,304,-fill=>'yellow');
$r->createRectangle(437,304,456,323,-fill=>'yellow');
$r->createRectangle(437,323,456,342,-fill=>"#DAA520");
$r->createRectangle(437,342,456,361,-fill=>'yellow');
$r->createRectangle(437,361,456,380,-fill=>"#DAA520");
$r->createRectangle(437,380,456,399,-fill=>"#DAA520");
$r->createRectangle(437,399,456,418,-fill=>'white');
$r->createRectangle(437,418,456,437,-fill=>'white');
$r->createRectangle(437,437,456,456,-fill=>'white');
$r->createRectangle(437,456,456,475,-fill=>'white');
$r->createRectangle(437,475,456,494,-fill=>'white');
$r->createRectangle(437,494,456,513,-fill=>'white');
$r->createRectangle(437,513,456,532,-fill=>'white');
$r->createRectangle(437,532,456,551,-fill=>'white');
$r->createRectangle(437,551,456,570,-fill=>'white');
$r->createRectangle(437,570,456,589,-fill=>"#DAA520");
$r->createRectangle(437,589,456,608,-fill=>"#DAA520");
$r->createRectangle(437,608,456,627,-fill=>'yellow');
$r->createRectangle(437,627,456,646,-fill=>'yellow');
$r->createRectangle(437,646,456,665,-fill=>'yellow');
$r->createRectangle(437,665,456,684,-fill=>"#DAA520");
#i=25;
$r->createRectangle(456,0,475,19,-fill=>"#DAA520");
$r->createRectangle(456,19,475,38,-fill=>'white');
$r->createRectangle(456,38,475,57,-fill=>'white');
$r->createRectangle(456,57,475,76,-fill=>'white');
$r->createRectangle(456,76,475,95,-fill=>'white');
$r->createRectangle(456,95,475,114,-fill=>'white');
$r->createRectangle(456,114,475,133,-fill=>"#DAA520");
$r->createRectangle(456,133,475,152,-fill=>"#DAA520");
$r->createRectangle(456,152,475,171,-fill=>'yellow');
$r->createRectangle(456,171,475,290,-fill=>'yellow');
$r->createRectangle(456,190,475,209,-fill=>'yellow');
$r->createRectangle(456,209,475,228,-fill=>'yellow');
$r->createRectangle(456,228,475,247,-fill=>'yellow');
$r->createRectangle(456,247,475,266,-fill=>'yellow');
$r->createRectangle(456,266,475,285,-fill=>'red');
$r->createRectangle(456,285,475,304,-fill=>'yellow');
$r->createRectangle(456,304,475,323,-fill=>'yellow');
$r->createRectangle(456,323,475,342,-fill=>'yellow');
$r->createRectangle(456,342,475,361,-fill=>"#DAA520");
$r->createRectangle(456,361,475,380,-fill=>"#DAA520");
$r->createRectangle(456,380,475,399,-fill=>"#DAA520");
$r->createRectangle(456,399,475,418,-fill=>'white');
$r->createRectangle(456,418,475,437,-fill=>'white');
$r->createRectangle(456,437,475,456,-fill=>'white');
$r->createRectangle(456,456,475,475,-fill=>'white');
$r->createRectangle(456,475,475,494,-fill=>'white');
$r->createRectangle(456,494,475,513,-fill=>'white');
$r->createRectangle(456,513,475,532,-fill=>'white');
$r->createRectangle(456,532,475,551,-fill=>'white');
$r->createRectangle(456,551,475,570,-fill=>'white');
$r->createRectangle(456,570,475,589,-fill=>"#DAA520");
$r->createRectangle(456,589,475,608,-fill=>"#DAA520");
$r->createRectangle(456,608,475,627,-fill=>"#DAA520");
$r->createRectangle(456,627,475,646,-fill=>"#DAA520");
$r->createRectangle(456,646,475,665,-fill=>'yellow');
$r->createRectangle(456,665,475,684,-fill=>"#DAA520");
#i=26;
$r->createRectangle(475,0,494,19,-fill=>"#DAA520");
$r->createRectangle(475,19,494,38,-fill=>'white');
$r->createRectangle(475,38,494,57,-fill=>'white');
$r->createRectangle(475,57,494,76,-fill=>'white');
$r->createRectangle(475,76,494,95,-fill=>'white');
$r->createRectangle(475,95,494,114,-fill=>'white');
$r->createRectangle(475,114,494,133,-fill=>"#DAA520");
$r->createRectangle(475,133,494,152,-fill=>"#DAA520");
$r->createRectangle(475,152,494,171,-fill=>'yellow');
$r->createRectangle(475,171,494,190,-fill=>"#DAA520");
$r->createRectangle(475,190,494,209,-fill=>"#DAA520");
$r->createRectangle(475,209,494,228,-fill=>"#DAA520");
$r->createRectangle(475,228,494,247,-fill=>'yellow');
$r->createRectangle(475,247,494,266,-fill=>'yellow');
$r->createRectangle(475,266,494,285,-fill=>'yellow');
$r->createRectangle(475,285,494,304,-fill=>'yellow');
$r->createRectangle(475,304,494,323,-fill=>'yellow');
$r->createRectangle(475,323,494,342,-fill=>'yellow');
$r->createRectangle(475,342,494,361,-fill=>'yellow');
$r->createRectangle(475,361,494,380,-fill=>"#DAA520");
$r->createRectangle(475,380,494,399,-fill=>"#DAA520");
$r->createRectangle(475,399,494,418,-fill=>'white');
$r->createRectangle(475,418,494,437,-fill=>'white');
$r->createRectangle(475,437,494,456,-fill=>'white');
$r->createRectangle(475,456,494,475,-fill=>'white');
$r->createRectangle(475,475,494,494,-fill=>'white');
$r->createRectangle(475,494,494,513,-fill=>'white');
$r->createRectangle(475,513,494,532,-fill=>'white');
$r->createRectangle(475,532,494,551,-fill=>'white');
$r->createRectangle(475,551,494,570,-fill=>'white');
$r->createRectangle(475,570,494,589,-fill=>"#DAA520");
$r->createRectangle(475,589,494,608,-fill=>"#DAA520");
$r->createRectangle(475,608,494,627,-fill=>"#DAA520");
$r->createRectangle(475,627,494,646,-fill=>"#DAA520");
$r->createRectangle(475,646,494,665,-fill=>"#DAA520");
$r->createRectangle(475,665,494,684,-fill=>"#DAA520");
#i=27;
$r->createRectangle(494,0,513,19,-fill=>'white');
$r->createRectangle(494,19,513,38,-fill=>'white');
$r->createRectangle(494,38,513,57,-fill=>'white');
$r->createRectangle(494,57,513,76,-fill=>'white');
$r->createRectangle(494,76,513,95,-fill=>'white');
$r->createRectangle(494,95,513,114,-fill=>'white');
$r->createRectangle(494,114,513,133,-fill=>"#DAA520");
$r->createRectangle(494,133,513,152,-fill=>"#DAA520");
$r->createRectangle(494,152,513,171,-fill=>"#DAA520");
$r->createRectangle(494,171,513,190,-fill=>"#DAA520");
$r->createRectangle(494,190,513,209,-fill=>"#DAA520");
$r->createRectangle(494,209,513,228,-fill=>"#DAA520");
$r->createRectangle(494,228,513,247,-fill=>'yellow');
$r->createRectangle(494,247,513,266,-fill=>"#DAA520");
$r->createRectangle(494,266,513,285,-fill=>"#DAA520");
$r->createRectangle(494,285,513,304,-fill=>'yellow');
$r->createRectangle(494,304,513,323,-fill=>"#DAA520");
$r->createRectangle(494,323,513,342,-fill=>'yellow');
$r->createRectangle(494,342,513,361,-fill=>'yellow');
$r->createRectangle(494,361,513,380,-fill=>"#DAA520");
$r->createRectangle(494,380,513,399,-fill=>"#DAA520");
$r->createRectangle(494,399,513,418,-fill=>'white');
$r->createRectangle(494,418,513,437,-fill=>'white');
$r->createRectangle(494,437,513,456,-fill=>'white');
$r->createRectangle(494,456,513,475,-fill=>'white');
$r->createRectangle(494,475,513,494,-fill=>'white');
$r->createRectangle(494,494,513,513,-fill=>'white');
$r->createRectangle(494,513,513,532,-fill=>'white');
$r->createRectangle(494,532,513,551,-fill=>'white');
$r->createRectangle(494,551,513,570,-fill=>'white');
$r->createRectangle(494,570,513,589,-fill=>'white');
$r->createRectangle(494,589,513,608,-fill=>'white');
$r->createRectangle(494,608,513,627,-fill=>"#DAA520");
$r->createRectangle(494,627,513,646,-fill=>"#DAA520");
$r->createRectangle(494,646,513,665,-fill=>"#DAA520");
$r->createRectangle(494,665,513,684,-fill=>"#DAA520");
#i=28;
$r->createRectangle(513,0,532,19,-fill=>'white');
$r->createRectangle(513,19,532,38,-fill=>'white');
$r->createRectangle(513,38,532,57,-fill=>'white');
$r->createRectangle(513,57,532,76,-fill=>'white');
$r->createRectangle(513,76,532,95,-fill=>'white');
$r->createRectangle(513,95,532,114,-fill=>'white');
$r->createRectangle(513,114,532,133,-fill=>"#DAA520");
$r->createRectangle(513,133,532,152,-fill=>"#DAA520");
$r->createRectangle(513,152,532,171,-fill=>"#DAA520");
$r->createRectangle(513,171,532,190,-fill=>"#DAA520");
$r->createRectangle(513,190,532,209,-fill=>"#DAA520");
$r->createRectangle(513,209,532,228,-fill=>"#DAA520");
$r->createRectangle(513,228,532,247,-fill=>"#DAA520");
$r->createRectangle(513,247,532,266,-fill=>"#DAA520");
$r->createRectangle(513,266,532,285,-fill=>"#DAA520");
$r->createRectangle(513,285,532,304,-fill=>"#DAA520");
$r->createRectangle(513,304,532,323,-fill=>"#DAA520");
$r->createRectangle(513,323,532,342,-fill=>"#DAA520");
$r->createRectangle(513,342,532,361,-fill=>"#DAA520");
$r->createRectangle(513,361,532,380,-fill=>"#DAA520");
$r->createRectangle(513,380,532,399,-fill=>"#DAA520");
$r->createRectangle(513,399,532,418,-fill=>'white');
$r->createRectangle(513,418,532,437,-fill=>'white');
$r->createRectangle(513,437,532,456,-fill=>'white');
$r->createRectangle(513,456,532,475,-fill=>'white');
$r->createRectangle(513,475,532,494,-fill=>'white');
$r->createRectangle(513,494,532,513,-fill=>'white');
$r->createRectangle(513,513,532,532,-fill=>'white');
$r->createRectangle(513,532,532,551,-fill=>'white');
$r->createRectangle(513,551,532,570,-fill=>'white');
$r->createRectangle(513,570,532,589,-fill=>'white');
$r->createRectangle(513,589,532,608,-fill=>'white');
$r->createRectangle(513,608,532,627,-fill=>'white');
$r->createRectangle(513,627,532,646,-fill=>'white');
$r->createRectangle(513,646,532,665,-fill=>'white');
$r->createRectangle(513,665,532,684,-fill=>'white');
#i=29;
$r->createRectangle(532,0,551,19,-fill=>'white');
$r->createRectangle(532,19,551,38,-fill=>'white');
$r->createRectangle(532,38,551,57,-fill=>'white');
$r->createRectangle(532,57,551,76,-fill=>'white');
$r->createRectangle(532,76,551,95,-fill=>'white');
$r->createRectangle(532,95,551,114,-fill=>'white');
$r->createRectangle(532,114,551,133,-fill=>'white');
$r->createRectangle(532,133,551,152,-fill=>'white');
$r->createRectangle(532,152,551,171,-fill=>'white');
$r->createRectangle(532,171,551,190,-fill=>'white');
$r->createRectangle(532,190,551,209,-fill=>'white');
$r->createRectangle(532,209,551,228,-fill=>"#DAA520");
$r->createRectangle(532,228,551,247,-fill=>"#DAA520");
$r->createRectangle(532,247,551,266,-fill=>"#DAA520");
$r->createRectangle(532,266,551,285,-fill=>"#DAA520");
$r->createRectangle(532,285,551,304,-fill=>"#DAA520");
$r->createRectangle(532,304,551,323,-fill=>"#DAA520");
$r->createRectangle(532,323,551,342,-fill=>"#DAA520");
$r->createRectangle(532,342,551,361,-fill=>"#DAA520");
$r->createRectangle(532,361,551,380,-fill=>"#DAA520");
$r->createRectangle(532,380,551,399,-fill=>"#DAA520");
$r->createRectangle(532,399,551,418,-fill=>'white');
$r->createRectangle(532,418,551,437,-fill=>'white');
$r->createRectangle(532,437,551,456,-fill=>'white');
$r->createRectangle(532,456,551,475,-fill=>'white');
$r->createRectangle(532,475,551,494,-fill=>'white');
$r->createRectangle(532,494,551,513,-fill=>'white');
$r->createRectangle(532,513,551,532,-fill=>'white');
$r->createRectangle(532,532,551,551,-fill=>'white');
$r->createRectangle(532,551,551,570,-fill=>'white');
$r->createRectangle(532,570,551,589,-fill=>'white');
$r->createRectangle(532,589,551,608,-fill=>'white');
$r->createRectangle(532,608,551,627,-fill=>'white');
$r->createRectangle(532,627,551,646,-fill=>'white');
$r->createRectangle(532,646,551,665,-fill=>'white');
$r->createRectangle(532,665,551,684,-fill=>'white');
#i=30;
$r->createRectangle(551,0,570,19,-fill=>'white');
$r->createRectangle(551,19,570,38,-fill=>'white');
$r->createRectangle(551,38,570,57,-fill=>'white');
$r->createRectangle(551,57,570,76,-fill=>'white');
$r->createRectangle(551,76,570,95,-fill=>'white');
$r->createRectangle(551,95,570,114,-fill=>'white');
$r->createRectangle(551,114,570,133,-fill=>'white');
$r->createRectangle(551,133,570,152,-fill=>'white');
$r->createRectangle(551,152,570,171,-fill=>'white');
$r->createRectangle(551,171,570,190,-fill=>'white');
$r->createRectangle(551,190,570,209,-fill=>'white');
$r->createRectangle(551,209,570,228,-fill=>'white');
$r->createRectangle(551,228,570,247,-fill=>'white');
$r->createRectangle(551,247,570,266,-fill=>'white');
$r->createRectangle(551,266,570,285,-fill=>'white');
$r->createRectangle(551,285,570,304,-fill=>'white');
$r->createRectangle(551,304,570,323,-fill=>'white');
$r->createRectangle(551,323,570,342,-fill=>'white');
$r->createRectangle(551,342,570,361,-fill=>'white');
$r->createRectangle(551,361,570,380,-fill=>'white');
$r->createRectangle(551,380,570,399,-fill=>'white');
$r->createRectangle(551,399,570,418,-fill=>'white');
$r->createRectangle(551,418,570,437,-fill=>'white');
$r->createRectangle(551,437,570,456,-fill=>'white');
$r->createRectangle(551,456,570,475,-fill=>'white');
$r->createRectangle(551,475,570,494,-fill=>'white');
$r->createRectangle(551,494,570,513,-fill=>'white');
$r->createRectangle(551,513,570,532,-fill=>'white');
$r->createRectangle(551,532,570,551,-fill=>'white');
$r->createRectangle(551,551,570,570,-fill=>'white');
$r->createRectangle(551,570,570,589,-fill=>'white');
$r->createRectangle(551,589,570,608,-fill=>'white');
$r->createRectangle(551,608,570,627,-fill=>'white');
$r->createRectangle(551,627,570,646,-fill=>'white');
$r->createRectangle(551,646,570,665,-fill=>'white');
$r->createRectangle(551,665,570,684,-fill=>'white');
#i=31;
$r->createRectangle(570,0,589,19,-fill=>'white');
$r->createRectangle(570,19,589,38,-fill=>'white');
$r->createRectangle(570,38,589,57,-fill=>'white');
$r->createRectangle(570,57,589,76,-fill=>'white');
$r->createRectangle(570,76,589,95,-fill=>'white');
$r->createRectangle(570,95,589,114,-fill=>'white');
$r->createRectangle(570,114,589,133,-fill=>'white');
$r->createRectangle(570,133,589,152,-fill=>'white');
$r->createRectangle(570,152,589,171,-fill=>'white');
$r->createRectangle(570,171,589,190,-fill=>'white');
$r->createRectangle(570,190,589,209,-fill=>'white');
$r->createRectangle(570,209,589,228,-fill=>'white');
$r->createRectangle(570,228,589,247,-fill=>'white');
$r->createRectangle(570,247,589,266,-fill=>'white');
$r->createRectangle(570,266,589,285,-fill=>'white');
$r->createRectangle(570,285,589,304,-fill=>'white');
$r->createRectangle(570,304,589,323,-fill=>'white');
$r->createRectangle(570,323,589,342,-fill=>'white');
$r->createRectangle(570,342,589,361,-fill=>'white');
$r->createRectangle(570,361,589,380,-fill=>'white');
$r->createRectangle(570,380,589,399,-fill=>'white');
$r->createRectangle(570,399,589,418,-fill=>'white');
$r->createRectangle(570,418,589,437,-fill=>'white');
$r->createRectangle(570,437,589,456,-fill=>'white');
$r->createRectangle(570,456,589,475,-fill=>'white');
$r->createRectangle(570,475,589,494,-fill=>'white');
$r->createRectangle(570,494,589,513,-fill=>'white');
$r->createRectangle(570,513,589,532,-fill=>'white');
$r->createRectangle(570,532,589,551,-fill=>'white');
$r->createRectangle(570,551,589,570,-fill=>'white');
$r->createRectangle(570,570,589,589,-fill=>'white');
$r->createRectangle(570,589,589,608,-fill=>'white');
$r->createRectangle(570,608,589,627,-fill=>'white');
$r->createRectangle(570,627,589,646,-fill=>'white');
$r->createRectangle(570,646,589,665,-fill=>'white');
$r->createRectangle(570,665,589,684,-fill=>'white');
#i=32;
$r->createRectangle(589,0,608,19,-fill=>"#DAA520");
$r->createRectangle(589,19,608,38,-fill=>"#DAA520");
$r->createRectangle(589,38,608,57,-fill=>"#DAA520");
$r->createRectangle(589,57,608,76,-fill=>"#DAA520");
$r->createRectangle(589,76,608,95,-fill=>"#DAA520");
$r->createRectangle(589,95,608,114,-fill=>'white');
$r->createRectangle(589,114,608,133,-fill=>'white');
$r->createRectangle(589,133,608,152,-fill=>'white');
$r->createRectangle(589,152,608,171,-fill=>'white');
$r->createRectangle(589,171,608,190,-fill=>'white');
$r->createRectangle(589,190,608,209,-fill=>'white');
$r->createRectangle(589,209,608,228,-fill=>'white');
$r->createRectangle(589,228,608,247,-fill=>'white');
$r->createRectangle(589,247,608,266,-fill=>'white');
$r->createRectangle(589,266,608,285,-fill=>'white');
$r->createRectangle(589,285,608,304,-fill=>'white');
$r->createRectangle(589,304,608,323,-fill=>'white');
$r->createRectangle(589,323,608,342,-fill=>'white');
$r->createRectangle(589,342,608,361,-fill=>'white');
$r->createRectangle(589,361,608,380,-fill=>'white');
$r->createRectangle(589,380,608,399,-fill=>'white');
$r->createRectangle(589,399,608,418,-fill=>'white');
$r->createRectangle(589,418,608,437,-fill=>'white');
$r->createRectangle(589,437,608,456,-fill=>'white');
$r->createRectangle(589,456,608,475,-fill=>'white');
$r->createRectangle(589,475,608,494,-fill=>'white');
$r->createRectangle(589,494,608,513,-fill=>'white');
$r->createRectangle(589,513,608,532,-fill=>'white');
$r->createRectangle(589,532,608,551,-fill=>'white');
$r->createRectangle(589,551,608,570,-fill=>'white');
$r->createRectangle(589,570,608,589,-fill=>'white');
$r->createRectangle(589,589,608,608,-fill=>'white');
$r->createRectangle(589,608,608,627,-fill=>'white');
$r->createRectangle(589,627,608,646,-fill=>'white');
$r->createRectangle(589,646,608,665,-fill=>'white');
$r->createRectangle(589,665,608,684,-fill=>'white');
#i=33;
$r->createRectangle(608,0,627,19,-fill=>"#DAA520");
$r->createRectangle(608,19,627,38,-fill=>"#DAA520");
$r->createRectangle(608,38,627,57,-fill=>"#DAA520");
$r->createRectangle(608,57,627,76,-fill=>"#DAA520");
$r->createRectangle(608,76,627,95,-fill=>"#DAA520");
$r->createRectangle(608,95,627,114,-fill=>"#DAA520");
$r->createRectangle(608,114,627,133,-fill=>'white');
$r->createRectangle(608,133,627,152,-fill=>'white');
$r->createRectangle(608,152,627,171,-fill=>'white');
$r->createRectangle(608,171,627,190,-fill=>'white');
$r->createRectangle(608,190,627,209,-fill=>'white');
$r->createRectangle(608,209,627,228,-fill=>'white');
$r->createRectangle(608,228,627,247,-fill=>'white');
$r->createRectangle(608,247,627,266,-fill=>'white');
$r->createRectangle(608,266,627,285,-fill=>'white');
$r->createRectangle(608,285,627,304,-fill=>'white');
$r->createRectangle(608,304,627,323,-fill=>'white');
$r->createRectangle(608,323,627,342,-fill=>'white');
$r->createRectangle(608,342,627,361,-fill=>'white');
$r->createRectangle(608,361,627,380,-fill=>'white');
$r->createRectangle(608,380,627,399,-fill=>'white');
$r->createRectangle(608,399,627,418,-fill=>'white');
$r->createRectangle(608,418,627,437,-fill=>'white');
$r->createRectangle(608,437,627,456,-fill=>'white');
$r->createRectangle(608,456,627,475,-fill=>'white');
$r->createRectangle(608,475,627,494,-fill=>'white');
$r->createRectangle(608,494,627,513,-fill=>'white');
$r->createRectangle(608,513,627,532,-fill=>'white');
$r->createRectangle(608,532,627,551,-fill=>'white');
$r->createRectangle(608,551,627,570,-fill=>'white');
$r->createRectangle(608,570,627,589,-fill=>'white');
$r->createRectangle(608,589,627,608,-fill=>'white');
$r->createRectangle(608,608,627,627,-fill=>'white');
$r->createRectangle(608,627,627,646,-fill=>'white');
$r->createRectangle(608,646,627,665,-fill=>'white');
$r->createRectangle(608,665,627,684,-fill=>'white');
#i=34;
$r->createRectangle(627,0,646,19,-fill=>"#DAA520");
$r->createRectangle(627,19,646,38,-fill=>"#DAA520");
$r->createRectangle(627,38,646,57,-fill=>'yellow');
$r->createRectangle(627,57,646,76,-fill=>"#DAA520");
$r->createRectangle(627,76,646,95,-fill=>"#DAA520");
$r->createRectangle(627,95,646,114,-fill=>"#DAA520");
$r->createRectangle(627,114,646,133,-fill=>"#DAA520");
$r->createRectangle(627,133,646,152,-fill=>"#DAA520");
$r->createRectangle(627,152,646,171,-fill=>"#DAA520");
$r->createRectangle(627,171,646,190,-fill=>"#DAA520");
$r->createRectangle(627,190,646,209,-fill=>"#DAA520");
$r->createRectangle(627,209,646,228,-fill=>"#DAA520");
$r->createRectangle(627,228,646,247,-fill=>"#DAA520");
$r->createRectangle(627,247,646,266,-fill=>"#DAA520");
$r->createRectangle(627,266,646,285,-fill=>"#DAA520");
$r->createRectangle(627,285,646,530,-fill=>"#DAA520");
$r->createRectangle(627,304,646,323,-fill=>"#DAA520");
$r->createRectangle(627,323,646,342,-fill=>"#DAA520");
$r->createRectangle(627,342,646,361,-fill=>"#DAA520");
$r->createRectangle(627,361,646,380,-fill=>"#DAA520");
$r->createRectangle(627,380,646,399,-fill=>"#DAA520");
$r->createRectangle(627,399,646,418,-fill=>"#DAA520");
$r->createRectangle(627,418,646,437,-fill=>"#DAA520");
$r->createRectangle(627,437,646,456,-fill=>"#DAA520");
$r->createRectangle(627,456,646,475,-fill=>"#DAA520");
$r->createRectangle(627,475,646,494,-fill=>"#DAA520");
$r->createRectangle(627,494,646,513,-fill=>"#DAA520");
$r->createRectangle(627,513,646,532,-fill=>'white');
$r->createRectangle(627,532,646,551,-fill=>'white');
$r->createRectangle(627,551,646,570,-fill=>'white');
$r->createRectangle(627,570,646,589,-fill=>'white');
$r->createRectangle(627,589,646,608,-fill=>'white');
$r->createRectangle(627,608,646,627,-fill=>'white');
$r->createRectangle(627,627,646,646,-fill=>"#DAA520");
$r->createRectangle(627,646,646,665,-fill=>"#DAA520");
$r->createRectangle(627,665,646,684,-fill=>"#DAA520");
#i=35;
$r->createRectangle(646,0,665,19,-fill=>"#DAA520");
$r->createRectangle(646,19,665,38,-fill=>'yellow');
$r->createRectangle(646,38,665,57,-fill=>'yellow');
$r->createRectangle(646,57,665,76,-fill=>'yellow');
$r->createRectangle(646,76,665,95,-fill=>"#DAA520");
$r->createRectangle(646,95,665,114,-fill=>"#DAA520");
$r->createRectangle(646,114,665,133,-fill=>"#DAA520");
$r->createRectangle(646,133,665,152,-fill=>"#DAA520");
$r->createRectangle(646,152,665,171,-fill=>"#DAA520");
$r->createRectangle(646,171,665,190,-fill=>"#DAA520");
$r->createRectangle(646,190,665,209,-fill=>"#DAA520");
$r->createRectangle(646,209,665,228,-fill=>"#DAA520");
$r->createRectangle(646,228,665,247,-fill=>"#DAA520");
$r->createRectangle(646,247,665,266,-fill=>"#DAA520");
$r->createRectangle(646,266,665,285,-fill=>"#DAA520");
$r->createRectangle(646,285,665,304,-fill=>"#DAA520");
$r->createRectangle(646,304,665,323,-fill=>"#DAA520");
$r->createRectangle(646,323,665,342,-fill=>"#DAA520");
$r->createRectangle(646,342,665,361,-fill=>"#DAA520");
$r->createRectangle(646,361,665,380,-fill=>"#DAA520");
$r->createRectangle(646,380,665,399,-fill=>"#DAA520");
$r->createRectangle(646,399,665,418,-fill=>"#DAA520");
$r->createRectangle(646,418,665,437,-fill=>"#DAA520");
$r->createRectangle(646,437,665,456,-fill=>"#DAA520");
$r->createRectangle(646,456,665,475,-fill=>"#DAA520");
$r->createRectangle(646,475,665,494,-fill=>"#DAA520");
$r->createRectangle(646,494,665,513,-fill=>"#DAA520");
$r->createRectangle(646,513,665,532,-fill=>'white');
$r->createRectangle(646,532,665,551,-fill=>'white');
$r->createRectangle(646,551,665,570,-fill=>'white');
$r->createRectangle(646,570,665,589,-fill=>'white');
$r->createRectangle(646,589,665,608,-fill=>'white');
$r->createRectangle(646,608,665,627,-fill=>'white');
$r->createRectangle(646,627,665,646,-fill=>"#DAA520");
$r->createRectangle(646,646,665,665,-fill=>"#DAA520");
$r->createRectangle(646,665,665,684,-fill=>"#DAA520");
#$i=36;
$r->createRectangle(665,0,684,19,-fill=>'yellow');
$r->createRectangle(665,19,684,38,-fill=>'yellow');
$r->createRectangle(665,38,684,57,-fill=>'yellow');
$r->createRectangle(665,57,684,76,-fill=>'yellow');
$r->createRectangle(665,76,684,95,-fill=>'yellow');
$r->createRectangle(665,95,684,114,-fill=>'yellow');
$r->createRectangle(665,114,684,133,-fill=>'yellow');
$r->createRectangle(665,133,684,152,-fill=>'yellow');
$r->createRectangle(665,152,684,171,-fill=>'yellow');
$r->createRectangle(665,171,684,190,-fill=>"#DAA520");
$r->createRectangle(665,190,684,209,-fill=>"#DAA520");
$r->createRectangle(665,209,684,228,-fill=>"#DAA520");
$r->createRectangle(665,228,684,247,-fill=>"#DAA520");
$r->createRectangle(665,247,684,266,-fill=>"#DAA520");
$r->createRectangle(665,266,684,285,-fill=>"#DAA520");
$r->createRectangle(665,285,684,304,-fill=>"#DAA520");
$r->createRectangle(665,304,684,323,-fill=>"#DAA520");
$r->createRectangle(665,323,684,342,-fill=>"#DAA520");
$r->createRectangle(665,342,684,361,-fill=>"#DAA520");
$r->createRectangle(665,361,684,380,-fill=>"#DAA520");
$r->createRectangle(665,380,684,399,-fill=>"#DAA520");
$r->createRectangle(665,399,684,418,-fill=>"#DAA520");
$r->createRectangle(665,418,684,437,-fill=>"#DAA520");
$r->createRectangle(665,437,684,456,-fill=>"#DAA520");
$r->createRectangle(665,456,684,475,-fill=>"#DAA520");
$r->createRectangle(665,475,684,494,-fill=>"#DAA520");
$r->createRectangle(665,494,684,513,-fill=>"#DAA520");
$r->createRectangle(665,513,684,532,-fill=>'white');
$r->createRectangle(665,532,684,551,-fill=>'white');
$r->createRectangle(665,551,684,570,-fill=>'white');
$r->createRectangle(665,570,684,589,-fill=>'white');
$r->createRectangle(665,589,684,608,-fill=>'white');
$r->createRectangle(665,608,684,627,-fill=>'white');
$r->createRectangle(665,627,684,646,-fill=>"#DAA520");
$r->createRectangle(665,646,684,665,-fill=>"#DAA520");
$r->createRectangle(665,665,684,684,-fill=>'yellow');
$r->createText(10,10,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(670,670,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(15,670,-fill =>'black',-text =>"-180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(343,670,-fill =>'black',-text =>"Phi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(40,343,-fill =>'black',-text =>"Psi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
$nc=500;
my $top_ram= $subframe2_ram;
my $arrayVar = {};
my ($rows,$cols)=($nc,5);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top_ram->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols,
-height =>31,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>15,2=>22,3=>22,4=>22);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$arrayVar->{"0,0"} = "Chain";
$arrayVar->{"0,1"} = "Residue Name";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "PHI angle";
$arrayVar->{"0,4"} = "PSI angle";
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
$s="";
$ram="";
$ramh="";
for($i=0;$i<scalar(@chains);$i++)
{
$s=$subframe1_ram->Radiobutton(-text=>$chains[$i],-value=>"$chains[$i]",-variable=>\$ram,-command=>sub {$ramh=$ram; ramram($ramh)},-font=>[-size =>'10'])->pack(-side=>'left');  
}
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any PDB file. Please select a PDB file *");
}
}
sub ramram
{
my($ram)=@_;
$frame2_ram->destroy();
$frame2_ram=$mw_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$frame2_ram->pack(-anchor=>'nw',-side=>'left',-expand=>0);
$subframe2_ram->destroy();
$subframe3_ram->destroy();
$subframe2_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe2_ram->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$subframe1_ram);
$subframe3_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe3_ram->pack(-side=>'top',-expand=>0,-fill=>'x');
my $scale = $subframe3_ram->Scale();
$scale->configure(-label        => 'Phi angles',
-orient       => 'horizontal',
-length       => 600,
-from         => -180,
-to           => 180,
-showvalue    => 'true',
-tickinterval => 25,
-variable     => \$scaleval,
-command      => sub{$phi=$scaleval; psiangle($phi,$ram)});
$scale->pack();
$scale1 = $subframe3_ram->Scale();
$scale1->configure(-label        => 'Psi angles',
-orient       => 'horizontal',
-length       => 600,
-from         => -180,
-to           => 180,
-showvalue    => 'true',
-tickinterval => 25,
-variable     => \$scaleval1,
-command      => [ \&ramrange, $scaleval1 ] );
$r=$frame2_ram->Canvas(-width =>686, -height =>686); 
$r->pack;
$r->createRectangle(0, 0,19,19,-fill=>'yellow');
$r->createRectangle(0,19,19,38,-fill=>'yellow');
$r->createRectangle(0,38,19,57,-fill=>'yellow');
$r->createRectangle(0,57,19,76,-fill=>'yellow');
$r->createRectangle(0,76,19,95,-fill=>'yellow');
$r->createRectangle(0,95,19,114,-fill=>'yellow');
$r->createRectangle(0,114,19,133,-fill=>'yellow');
$r->createRectangle(0,133,19,152,-fill=>'yellow');
$r->createRectangle(0,152,19,171,-fill=>'yellow');
$r->createRectangle(0,171,19,190,-fill=>'yellow');
$r->createRectangle(0,190,19,209,-fill=>'yellow');
$r->createRectangle(0,209,19,228,-fill=>"#DAA520");
$r->createRectangle(0,228,19,247,-fill=>"#DAA520");
$r->createRectangle(0,247,19,266,-fill=>"#DAA520");
$r->createRectangle(0,266,19,285,-fill=>"#DAA520");
$r->createRectangle(0,285,19,304,-fill=>"#DAA520");
$r->createRectangle(0,304,19,323,-fill=>"#DAA520");
$r->createRectangle(0,323,19,342,-fill=>"#DAA520");
$r->createRectangle(0,342,19,361,-fill=>"#DAA520");
$r->createRectangle(0,361,19,380,-fill=>"#DAA520");
$r->createRectangle(0,380,19,399,-fill=>"#DAA520");
$r->createRectangle(0,399,19,418,-fill=>"#DAA520");
$r->createRectangle(0,418,19,437,-fill=>"#DAA520");
$r->createRectangle(0,437,19,456,-fill=>"#DAA520");
$r->createRectangle(0,456,19,475,-fill=>'yellow');
$r->createRectangle(0,475,19,494,-fill=>"#DAA520");
$r->createRectangle(0,494,19,513,-fill=>"#DAA520");
$r->createRectangle(0,513,19,532,-fill=>'white');
$r->createRectangle(0,532,19,551,-fill=>'white');
$r->createRectangle(0,551,19,570,-fill=>'white');
$r->createRectangle(0,570,19,589,-fill=>"#DAA520");
$r->createRectangle(0,589,19,608,-fill=>"#DAA520");
$r->createRectangle(0,608,19,627,-fill=>"#DAA520");
$r->createRectangle(0,627,19,646,-fill=>"#DAA520");
$r->createRectangle(0,646,19,665,-fill=>"#DAA520");
$r->createRectangle(0,665,19,684,-fill=>'yellow');
#i=2;
$r->createRectangle(19,0,38,19,-fill=>'red');
$r->createRectangle(19,19,38,38,-fill=>'red');
$r->createRectangle(19,38,38,57,-fill=>'red');
$r->createRectangle(19,57,38,76,-fill=>'yellow');
$r->createRectangle(19,76,38,95,-fill=>'yellow');
$r->createRectangle(19,95,38,114,-fill=>'yellow');
$r->createRectangle(19,114,38,133,-fill=>'yellow');
$r->createRectangle(19,133,38,152,-fill=>'yellow');
$r->createRectangle(19,152,38,171,-fill=>'yellow');
$r->createRectangle(19,171,38,190,-fill=>'yellow');
$r->createRectangle(19,190,38,209,-fill=>'yellow');
$r->createRectangle(19,209,38,228,-fill=>'yellow');
$r->createRectangle(19,228,38,247,-fill=>"#DAA520");
$r->createRectangle(19,247,38,266,-fill=>"#DAA520");
$r->createRectangle(19,266,38,285,-fill=>'yellow');
$r->createRectangle(19,285,38,304,-fill=>'yellow');
$r->createRectangle(19,304,38,323,-fill=>'yellow');
$r->createRectangle(19,323,38,342,-fill=>'yellow');
$r->createRectangle(19,342,38,361,-fill=>'yellow');
$r->createRectangle(19,361,38,380,-fill=>'yellow');
$r->createRectangle(19,380,38,399,-fill=>"#DAA520");
$r->createRectangle(19,399,38,418,-fill=>"#DAA520");
$r->createRectangle(19,418,38,437,-fill=>"#DAA520");
$r->createRectangle(19,437,38,456,-fill=>'yellow');
$r->createRectangle(19,456,38,475,-fill=>'yellow');
$r->createRectangle(19,475,38,494,-fill=>"#DAA520");
$r->createRectangle(19,494,38,513,-fill=>"#DAA520");
$r->createRectangle(19,513,38,532,-fill=>"#DAA520");
$r->createRectangle(19,532,38,551,-fill=>'white');
$r->createRectangle(19,551,38,570,-fill=>'white');
$r->createRectangle(19,570,38,589,-fill=>"#DAA520");
$r->createRectangle(19,589,38,608,-fill=>"#DAA520");
$r->createRectangle(19,608,38,627,-fill=>'yellow');
$r->createRectangle(19,627,38,646,-fill=>'yellow');
$r->createRectangle(19,646,38,665,-fill=>'yellow');
$r->createRectangle(19,665,38,684,-fill=>'yellow');
#i=3;
$r->createRectangle(38,0,57,19,-fill=>'red');
$r->createRectangle(38,19,57,38,-fill=>'red');
$r->createRectangle(38,38,57,57,-fill=>'red');
$r->createRectangle(38,57,57,76,-fill=>'red');
$r->createRectangle(38,76,57,95,-fill=>'red');
$r->createRectangle(38,95,57,114,-fill=>'red');
$r->createRectangle(38,114,57,133,-fill=>'yellow');
$r->createRectangle(38,133,57,152,-fill=>'yellow');
$r->createRectangle(38,152,57,171,-fill=>'yellow');
$r->createRectangle(38,171,57,190,-fill=>'yellow');
$r->createRectangle(38,190,57,209,-fill=>'yellow');
$r->createRectangle(38,209,57,228,-fill=>'yellow');
$r->createRectangle(38,228,57,247,-fill=>'yellow');
$r->createRectangle(38,247,57,266,-fill=>'yellow');
$r->createRectangle(38,266,57,285,-fill=>'yellow');
$r->createRectangle(38,285,57,304,-fill=>'yellow');
$r->createRectangle(38,304,57,323,-fill=>'yellow');
$r->createRectangle(38,323,57,342,-fill=>'yellow');
$r->createRectangle(38,342,57,361,-fill=>'yellow');
$r->createRectangle(38,361,57,380,-fill=>'yellow');
$r->createRectangle(38,380,57,399,-fill=>'yellow');
$r->createRectangle(38,399,57,418,-fill=>'yellow');
$r->createRectangle(38,418,57,437,-fill=>"#DAA520");
$r->createRectangle(38,437,57,456,-fill=>'yellow');
$r->createRectangle(38,456,57,475,-fill=>"#DAA520");
$r->createRectangle(38,475,57,494,-fill=>"#DAA520");
$r->createRectangle(38,494,57,513,-fill=>"#DAA520");
$r->createRectangle(38,513,57,532,-fill=>"#DAA520");
$r->createRectangle(38,532,57,551,-fill=>'white');
$r->createRectangle(38,551,57,570,-fill=>'white');
$r->createRectangle(38,570,57,589,-fill=>"#DAA520");
$r->createRectangle(38,589,57,608,-fill=>"#DAA520");
$r->createRectangle(38,608,57,627,-fill=>'yellow');
$r->createRectangle(38,627,57,646,-fill=>'yellow');
$r->createRectangle(38,646,57,665,-fill=>'yellow');
$r->createRectangle(38,665,57,684,-fill=>'yellow');
#i=4;
$r->createRectangle(57,0,76,19,-fill=>'red');
$r->createRectangle(57,19,76,38,-fill=>'red');
$r->createRectangle(57,38,76,57,-fill=>'red');
$r->createRectangle(57,57,76,76,-fill=>'red');
$r->createRectangle(57,76,76,95,-fill=>'red');
$r->createRectangle(57,95,76,114,-fill=>'red');
$r->createRectangle(57,114,76,133,-fill=>'red');
$r->createRectangle(57,133,76,152,-fill=>'yellow');
$r->createRectangle(57,152,76,171,-fill=>'yellow');
$r->createRectangle(57,171,76,190,-fill=>'yellow');
$r->createRectangle(57,190,76,209,-fill=>'yellow');
$r->createRectangle(57,209,76,228,-fill=>'yellow');
$r->createRectangle(57,228,76,247,-fill=>'yellow');
$r->createRectangle(57,247,76,266,-fill=>'yellow');
$r->createRectangle(57,266,76,285,-fill=>'yellow');
$r->createRectangle(57,285,76,304,-fill=>'yellow');
$r->createRectangle(57,304,76,323,-fill=>'yellow');
$r->createRectangle(57,323,76,342,-fill=>'yellow');
$r->createRectangle(57,342,76,361,-fill=>'yellow');
$r->createRectangle(57,361,76,380,-fill=>'yellow');
$r->createRectangle(57,380,76,399,-fill=>'yellow');
$r->createRectangle(57,399,76,418,-fill=>'yellow');
$r->createRectangle(57,418,76,437,-fill=>'yellow');
$r->createRectangle(57,437,76,456,-fill=>'yellow');
$r->createRectangle(57,456,76,475,-fill=>'yellow');
$r->createRectangle(57,475,76,494,-fill=>'yellow');
$r->createRectangle(57,494,76,513,-fill=>"#DAA520");
$r->createRectangle(57,513,76,532,-fill=>"#DAA520");
$r->createRectangle(57,532,76,551,-fill=>"#DAA520");
$r->createRectangle(57,551,76,570,-fill=>"#DAA520");
$r->createRectangle(57,570,76,589,-fill=>"#DAA520");
$r->createRectangle(57,589,76,608,-fill=>"#DAA520");
$r->createRectangle(57,608,76,627,-fill=>'yellow');
$r->createRectangle(57,627,76,646,-fill=>'yellow');
$r->createRectangle(57,646,76,665,-fill=>'yellow');
$r->createRectangle(57,665,76,684,-fill=>'yellow');
#i=5;
$r->createRectangle(76,0,95,19,-fill=>'red');
$r->createRectangle(76,19,95,38,-fill=>'red');
$r->createRectangle(76,38,95,57,-fill=>'red');
$r->createRectangle(76,57,95,76,-fill=>'red');
$r->createRectangle(76,76,95,95,-fill=>'red');
$r->createRectangle(76,95,95,114,-fill=>'red');
$r->createRectangle(76,114,95,133,-fill=>'red');
$r->createRectangle(76,133,95,152,-fill=>'red');
$r->createRectangle(76,152,95,171,-fill=>'yellow');
$r->createRectangle(76,171,95,190,-fill=>'yellow');
$r->createRectangle(76,190,95,209,-fill=>'yellow');
$r->createRectangle(76,209,95,228,-fill=>'yellow');
$r->createRectangle(76,228,95,247,-fill=>'yellow');
$r->createRectangle(76,247,95,266,-fill=>'yellow');
$r->createRectangle(76,266,95,285,-fill=>'yellow');
$r->createRectangle(76,285,95,304,-fill=>'yellow');
$r->createRectangle(76,304,95,323,-fill=>'yellow');
$r->createRectangle(76,323,95,342,-fill=>'yellow');
$r->createRectangle(76,342,95,361,-fill=>'yellow');
$r->createRectangle(76,361,95,380,-fill=>'yellow');
$r->createRectangle(76,380,95,399,-fill=>'yellow');
$r->createRectangle(76,399,95,418,-fill=>'yellow');
$r->createRectangle(76,418,95,437,-fill=>'yellow');
$r->createRectangle(76,437,95,456,-fill=>'yellow');
$r->createRectangle(76,456,95,475,-fill=>'yellow');
$r->createRectangle(76,475,95,494,-fill=>'yellow');
$r->createRectangle(76,494,95,513,-fill=>"#DAA520");
$r->createRectangle(76,513,95,532,-fill=>"#DAA520");
$r->createRectangle(76,532,95,551,-fill=>"#DAA520");
$r->createRectangle(76,551,95,570,-fill=>"#DAA520");
$r->createRectangle(76,570,95,589,-fill=>"#DAA520");
$r->createRectangle(76,589,95,608,-fill=>"#DAA520");
$r->createRectangle(76,608,95,627,-fill=>"#DAA520");
$r->createRectangle(76,627,95,646,-fill=>'yellow');
$r->createRectangle(76,646,95,665,-fill=>'yellow');
$r->createRectangle(76,665,95,684,-fill=>'yellow');
#i=6;
$r->createRectangle(95,0,114,19,-fill=>'red');
$r->createRectangle(95,19,114,38,-fill=>'red');
$r->createRectangle(95,38,114,57,-fill=>'red');
$r->createRectangle(95,57,114,76,-fill=>'red');
$r->createRectangle(95,76,114,95,-fill=>'red');
$r->createRectangle(95,95,114,114,-fill=>'red');
$r->createRectangle(95,114,114,133,-fill=>'red');
$r->createRectangle(95,133,114,152,-fill=>'red');
$r->createRectangle(95,152,114,171,-fill=>'red');
$r->createRectangle(95,171,114,190,-fill=>'yellow');
$r->createRectangle(95,190,114,209,-fill=>'yellow');
$r->createRectangle(95,209,114,228,-fill=>'yellow');
$r->createRectangle(95,228,114,247,-fill=>'yellow');
$r->createRectangle(95,247,114,266,-fill=>'yellow');
$r->createRectangle(95,266,114,285,-fill=>'yellow');
$r->createRectangle(95,285,114,304,-fill=>'yellow');
$r->createRectangle(95,304,114,323,-fill=>'yellow');
$r->createRectangle(95,323,114,342,-fill=>'yellow');
$r->createRectangle(95,342,114,361,-fill=>'red');
$r->createRectangle(95,361,114,380,-fill=>'yellow');
$r->createRectangle(95,380,114,399,-fill=>'yellow');
$r->createRectangle(95,399,114,418,-fill=>'yellow');
$r->createRectangle(95,418,114,437,-fill=>'yellow');
$r->createRectangle(95,437,114,456,-fill=>'yellow');
$r->createRectangle(95,456,114,475,-fill=>'yellow');
$r->createRectangle(95,475,114,494,-fill=>'yellow');
$r->createRectangle(95,494,114,513,-fill=>'yellow');
$r->createRectangle(95,513,114,532,-fill=>'yellow');
$r->createRectangle(95,532,114,551,-fill=>"#DAA520");
$r->createRectangle(95,551,114,570,-fill=>"#DAA520");
$r->createRectangle(95,570,114,589,-fill=>'yellow');
$r->createRectangle(95,589,114,608,-fill=>"#DAA520");
$r->createRectangle(95,608,114,627,-fill=>'yellow');
$r->createRectangle(95,627,114,646,-fill=>'yellow');
$r->createRectangle(95,646,114,665,-fill=>'yellow');
$r->createRectangle(95,665,114,684,-fill=>'yellow');
#i=7;
$r->createRectangle(114,0,133,19,-fill=>'red');
$r->createRectangle(114,19,133,38,-fill=>'red');
$r->createRectangle(114,38,133,57,-fill=>'red');
$r->createRectangle(114,57,133,76,-fill=>'red');
$r->createRectangle(114,76,133,95,-fill=>'red');
$r->createRectangle(114,95,133,114,-fill=>'red');
$r->createRectangle(114,114,133,133,-fill=>'red');
$r->createRectangle(114,133,133,152,-fill=>'red');
$r->createRectangle(114,152,133,171,-fill=>'yellow');
$r->createRectangle(114,171,133,190,-fill=>'yellow');
$r->createRectangle(114,190,133,209,-fill=>'yellow');
$r->createRectangle(114,209,133,228,-fill=>'yellow');
$r->createRectangle(114,228,133,247,-fill=>'yellow');
$r->createRectangle(114,247,133,266,-fill=>'yellow');
$r->createRectangle(114,266,133,285,-fill=>'yellow');
$r->createRectangle(114,285,133,304,-fill=>'yellow');
$r->createRectangle(114,304,133,323,-fill=>'red');
$r->createRectangle(114,323,133,342,-fill=>'red');
$r->createRectangle(114,342,133,361,-fill=>'red');
$r->createRectangle(114,361,133,380,-fill=>'yellow');
$r->createRectangle(114,380,133,399,-fill=>'yellow');
$r->createRectangle(114,399,133,418,-fill=>'yellow');
$r->createRectangle(114,418,133,437,-fill=>'yellow');
$r->createRectangle(114,437,133,456,-fill=>'yellow');
$r->createRectangle(114,456,133,475,-fill=>'yellow');
$r->createRectangle(114,475,133,494,-fill=>'yellow');
$r->createRectangle(114,494,133,513,-fill=>"#DAA520");
$r->createRectangle(114,513,133,532,-fill=>"#DAA520");
$r->createRectangle(114,532,133,551,-fill=>"#DAA520");
$r->createRectangle(114,551,133,570,-fill=>'yellow');
$r->createRectangle(114,570,133,589,-fill=>'yellow');
$r->createRectangle(114,589,133,608,-fill=>'yellow');
$r->createRectangle(114,608,133,627,-fill=>'yellow');
$r->createRectangle(114,627,133,646,-fill=>'yellow');
$r->createRectangle(114,646,133,665,-fill=>'yellow');
$r->createRectangle(114,665,133,684,-fill=>'yellow');
#i=8;
$r->createRectangle(133,0,152,19,-fill=>'red');
$r->createRectangle(133,19,152,38,-fill=>'red');
$r->createRectangle(133,38,152,57,-fill=>'red');
$r->createRectangle(133,57,152,76,-fill=>'red');
$r->createRectangle(133,76,152,95,-fill=>'red');
$r->createRectangle(133,95,152,114,-fill=>'red');
$r->createRectangle(133,114,152,133,-fill=>'red');
$r->createRectangle(133,133,152,152,-fill=>'red');
$r->createRectangle(133,152,152,171,-fill=>'yellow');
$r->createRectangle(133,171,152,190,-fill=>'yellow');
$r->createRectangle(133,190,152,209,-fill=>'yellow');
$r->createRectangle(133,209,152,228,-fill=>'yellow');
$r->createRectangle(133,228,152,247,-fill=>'yellow');
$r->createRectangle(133,247,152,266,-fill=>'yellow');
$r->createRectangle(133,266,152,285,-fill=>'yellow');
$r->createRectangle(133,285,152,304,-fill=>'red');
$r->createRectangle(133,304,152,323,-fill=>'red');
$r->createRectangle(133,323,152,342,-fill=>'red');
$r->createRectangle(133,342,152,361,-fill=>'red');
$r->createRectangle(133,361,152,380,-fill=>'red');
$r->createRectangle(133,380,152,399,-fill=>'red');
$r->createRectangle(133,399,152,418,-fill=>'red');
$r->createRectangle(133,418,152,437,-fill=>'yellow');
$r->createRectangle(133,437,152,456,-fill=>'yellow');
$r->createRectangle(133,456,152,475,-fill=>'yellow');
$r->createRectangle(133,475,152,494,-fill=>'yellow');
$r->createRectangle(133,494,152,513,-fill=>'yellow');
$r->createRectangle(133,513,152,532,-fill=>'yellow');
$r->createRectangle(133,532,152,551,-fill=>"#DAA520");
$r->createRectangle(133,551,152,570,-fill=>'yellow');
$r->createRectangle(133,570,152,589,-fill=>"#DAA520");
$r->createRectangle(133,589,152,608,-fill=>'yellow');
$r->createRectangle(133,608,152,627,-fill=>'yellow');
$r->createRectangle(133,627,152,646,-fill=>'yellow');
$r->createRectangle(133,646,152,665,-fill=>'yellow');
$r->createRectangle(133,665,152,684,-fill=>'yellow');
#i=9;
$r->createRectangle(152,0,171,19,-fill=>'red');
$r->createRectangle(152,19,171,38,-fill=>'red');
$r->createRectangle(152,38,171,57,-fill=>'red');
$r->createRectangle(152,57,171,76,-fill=>'red');
$r->createRectangle(152,76,171,95,-fill=>'red');
$r->createRectangle(152,95,171,114,-fill=>'red');
$r->createRectangle(152,114,171,133,-fill=>'red');
$r->createRectangle(152,133,171,152,-fill=>'red');
$r->createRectangle(152,152,171,171,-fill=>'red');
$r->createRectangle(152,171,171,190,-fill=>'yellow');
$r->createRectangle(152,190,171,209,-fill=>'yellow');
$r->createRectangle(152,209,171,228,-fill=>'yellow');
$r->createRectangle(152,228,171,247,-fill=>'yellow');
$r->createRectangle(152,247,171,266,-fill=>'yellow');
$r->createRectangle(152,266,171,285,-fill=>'yellow');
$r->createRectangle(152,285,171,304,-fill=>'yellow');
$r->createRectangle(152,304,171,323,-fill=>'red');
$r->createRectangle(152,323,171,342,-fill=>'red');
$r->createRectangle(152,342,171,361,-fill=>'red');
$r->createRectangle(152,361,171,380,-fill=>'red');
$r->createRectangle(152,380,171,399,-fill=>'red');
$r->createRectangle(152,399,171,418,-fill=>'red');
$r->createRectangle(152,418,171,437,-fill=>'red');
$r->createRectangle(152,437,171,456,-fill=>'yellow');
$r->createRectangle(152,456,171,475,-fill=>'yellow');
$r->createRectangle(152,475,171,494,-fill=>'yellow');
$r->createRectangle(152,494,171,513,-fill=>'yellow');
$r->createRectangle(152,513,171,532,-fill=>'yellow');
$r->createRectangle(152,532,171,551,-fill=>"#DAA520");
$r->createRectangle(152,551,171,570,-fill=>'yellow');
$r->createRectangle(152,570,171,589,-fill=>"#DAA520");
$r->createRectangle(152,589,171,608,-fill=>'yellow');
$r->createRectangle(152,608,171,627,-fill=>'yellow');
$r->createRectangle(152,627,171,646,-fill=>'yellow');
$r->createRectangle(152,646,171,665,-fill=>'yellow');
$r->createRectangle(152,665,171,684,-fill=>'yellow');
#i=10;
$r->createRectangle(171,0,190,19,-fill=>'red');
$r->createRectangle(171,19,190,38,-fill=>'red');
$r->createRectangle(171,38,190,57,-fill=>'red');
$r->createRectangle(171,57,190,76,-fill=>'red');
$r->createRectangle(171,76,190,95,-fill=>'red');
$r->createRectangle(171,95,190,114,-fill=>'red');
$r->createRectangle(171,114,190,133,-fill=>'red');
$r->createRectangle(171,133,190,152,-fill=>'red');
$r->createRectangle(171,152,190,171,-fill=>'yellow');
$r->createRectangle(171,171,190,190,-fill=>'yellow');
$r->createRectangle(171,190,190,209,-fill=>'yellow');
$r->createRectangle(171,209,190,228,-fill=>'yellow');
$r->createRectangle(171,228,190,247,-fill=>'yellow');
$r->createRectangle(171,247,190,266,-fill=>'yellow');
$r->createRectangle(171,266,190,285,-fill=>'yellow');
$r->createRectangle(171,285,190,304,-fill=>'yellow');
$r->createRectangle(171,304,190,323,-fill=>'red');
$r->createRectangle(171,323,190,342,-fill=>'red');
$r->createRectangle(171,342,190,361,-fill=>'red');
$r->createRectangle(171,361,190,380,-fill=>'red');
$r->createRectangle(171,380,190,399,-fill=>'red');
$r->createRectangle(171,399,190,418,-fill=>'red');
$r->createRectangle(171,418,190,437,-fill=>'red');
$r->createRectangle(171,437,190,456,-fill=>'red');
$r->createRectangle(171,456,190,475,-fill=>'yellow');
$r->createRectangle(171,475,190,494,-fill=>'yellow');
$r->createRectangle(171,494,190,513,-fill=>'yellow');
$r->createRectangle(171,513,190,532,-fill=>'yellow');
$r->createRectangle(171,532,190,551,-fill=>"#DAA520");
$r->createRectangle(171,551,190,570,-fill=>"#DAA520");
$r->createRectangle(171,570,190,589,-fill=>"#DAA520");
$r->createRectangle(171,589,190,608,-fill=>'yellow');
$r->createRectangle(171,608,190,627,-fill=>'yellow');
$r->createRectangle(171,627,190,646,-fill=>'yellow');
$r->createRectangle(171,646,190,665,-fill=>'yellow');
$r->createRectangle(171,665,190,684,-fill=>'yellow');
#i=11;
$r->createRectangle(190,0,209,19,-fill=>'red');
$r->createRectangle(190,19,209,38,-fill=>'red');
$r->createRectangle(190,38,209,57,-fill=>'red');
$r->createRectangle(190,57,209,76,-fill=>'red');
$r->createRectangle(190,76,209,95,-fill=>'red');
$r->createRectangle(190,95,209,114,-fill=>'red');
$r->createRectangle(190,114,209,133,-fill=>'red');
$r->createRectangle(190,133,209,152,-fill=>'red');
$r->createRectangle(190,152,209,171,-fill=>'yellow');
$r->createRectangle(190,171,209,190,-fill=>'yellow');
$r->createRectangle(190,190,209,209,-fill=>'yellow');
$r->createRectangle(190,209,209,228,-fill=>'yellow');
$r->createRectangle(190,228,209,247,-fill=>'yellow');
$r->createRectangle(190,247,209,266,-fill=>'yellow');
$r->createRectangle(190,266,209,285,-fill=>'yellow');
$r->createRectangle(190,285,209,304,-fill=>'yellow');
$r->createRectangle(190,304,209,323,-fill=>'yellow');
$r->createRectangle(190,323,209,342,-fill=>'red');
$r->createRectangle(190,342,209,361,-fill=>'red');
$r->createRectangle(190,361,209,380,-fill=>'red');
$r->createRectangle(190,380,209,399,-fill=>'red');
$r->createRectangle(190,399,209,418,-fill=>'red');
$r->createRectangle(190,418,209,437,-fill=>'red');
$r->createRectangle(190,437,209,456,-fill=>'red');
$r->createRectangle(190,456,209,475,-fill=>'yellow');
$r->createRectangle(190,475,209,494,-fill=>'yellow');
$r->createRectangle(190,494,209,513,-fill=>'yellow');
$r->createRectangle(190,513,209,532,-fill=>'yellow');
$r->createRectangle(190,532,209,551,-fill=>"#DAA520");
$r->createRectangle(190,551,209,570,-fill=>"#DAA520");
$r->createRectangle(190,570,209,589,-fill=>"#DAA520");
$r->createRectangle(190,589,209,608,-fill=>"#DAA520");
$r->createRectangle(190,608,209,627,-fill=>"#DAA520");
$r->createRectangle(190,627,209,646,-fill=>'yellow');
$r->createRectangle(190,646,209,665,-fill=>'yellow');
$r->createRectangle(190,665,209,684,-fill=>'yellow');
#i=12;
$r->createRectangle(209,0,228,19,-fill=>'yellow');
$r->createRectangle(209,19,228,38,-fill=>'red');
$r->createRectangle(209,38,228,57,-fill=>'red');
$r->createRectangle(209,57,228,76,-fill=>'red');
$r->createRectangle(209,76,228,95,-fill=>'red');
$r->createRectangle(209,95,228,114,-fill=>'red');
$r->createRectangle(209,114,228,133,-fill=>'red');
$r->createRectangle(209,133,228,152,-fill=>'yellow');
$r->createRectangle(209,152,228,171,-fill=>'yellow');
$r->createRectangle(209,171,228,190,-fill=>'yellow');
$r->createRectangle(209,190,228,209,-fill=>'yellow');
$r->createRectangle(209,209,228,228,-fill=>'yellow');
$r->createRectangle(209,228,228,247,-fill=>'yellow');
$r->createRectangle(209,247,228,266,-fill=>'yellow');
$r->createRectangle(209,266,228,285,-fill=>'yellow');
$r->createRectangle(209,285,228,304,-fill=>'yellow');
$r->createRectangle(209,304,228,323,-fill=>'yellow');
$r->createRectangle(209,323,228,342,-fill=>'yellow');
$r->createRectangle(209,342,228,361,-fill=>'red');
$r->createRectangle(209,361,228,380,-fill=>'red');
$r->createRectangle(209,380,228,399,-fill=>'red');
$r->createRectangle(209,399,228,418,-fill=>'red');
$r->createRectangle(209,418,228,437,-fill=>'red');
$r->createRectangle(209,437,228,456,-fill=>'red');
$r->createRectangle(209,456,228,475,-fill=>'red');
$r->createRectangle(209,475,228,494,-fill=>'yellow');
$r->createRectangle(209,494,228,513,-fill=>'yellow');
$r->createRectangle(209,513,228,532,-fill=>'yellow');
$r->createRectangle(209,532,228,551,-fill=>'yellow');
$r->createRectangle(209,551,228,570,-fill=>"#DAA520");
$r->createRectangle(209,570,228,589,-fill=>"#DAA520");
$r->createRectangle(209,589,228,608,-fill=>"#DAA520");
$r->createRectangle(209,608,228,627,-fill=>"#DAA520");
$r->createRectangle(209,627,228,646,-fill=>"#DAA520");
$r->createRectangle(209,646,228,665,-fill=>'yellow');
$r->createRectangle(209,665,228,684,-fill=>'yellow');
#i=13;
$r->createRectangle(228,0,247,19,-fill=>'yellow');
$r->createRectangle(228,19,247,38,-fill=>'yellow');
$r->createRectangle(228,38,247,57,-fill=>'yellow');
$r->createRectangle(228,57,247,76,-fill=>'red');
$r->createRectangle(228,76,247,95,-fill=>'red');
$r->createRectangle(228,95,247,114,-fill=>'red');
$r->createRectangle(228,114,247,133,-fill=>'yellow');
$r->createRectangle(228,133,247,152,-fill=>'yellow');
$r->createRectangle(228,152,247,171,-fill=>'yellow');
$r->createRectangle(228,171,247,190,-fill=>'yellow');
$r->createRectangle(228,190,247,209,-fill=>"#DAA520");
$r->createRectangle(228,209,247,228,-fill=>'yellow');
$r->createRectangle(228,228,247,247,-fill=>'yellow');
$r->createRectangle(228,247,247,266,-fill=>"#DAA520");
$r->createRectangle(228,266,247,285,-fill=>"#DAA520");
$r->createRectangle(228,285,247,304,-fill=>'yellow');
$r->createRectangle(228,304,247,323,-fill=>'yellow');
$r->createRectangle(228,323,247,342,-fill=>'yellow');
$r->createRectangle(228,342,247,361,-fill=>'yellow');
$r->createRectangle(228,361,247,380,-fill=>'red');
$r->createRectangle(228,380,247,399,-fill=>'red');
$r->createRectangle(228,399,247,418,-fill=>'red');
$r->createRectangle(228,418,247,437,-fill=>'red');
$r->createRectangle(228,437,247,456,-fill=>'red');
$r->createRectangle(228,456,247,475,-fill=>'red');
$r->createRectangle(228,475,247,494,-fill=>'yellow');
$r->createRectangle(228,494,247,513,-fill=>'yellow');
$r->createRectangle(228,513,247,532,-fill=>'yellow');
$r->createRectangle(228,532,247,551,-fill=>"#DAA520");
$r->createRectangle(228,551,247,570,-fill=>"#DAA520");
$r->createRectangle(228,570,247,589,-fill=>"#DAA520");
$r->createRectangle(228,589,247,608,-fill=>"#DAA520");
$r->createRectangle(228,608,247,627,-fill=>"#DAA520");
$r->createRectangle(228,627,247,646,,-fill=>"#DAA520");
$r->createRectangle(228,646,247,665,-fill=>'yellow');
$r->createRectangle(228,665,247,684,-fill=>'yellow');
#i=14;
$r->createRectangle(247,0,266,19,-fill=>'yellow');
$r->createRectangle(247,19,266,38,-fill=>'yellow');
$r->createRectangle(247,38,266,57,-fill=>'yellow');
$r->createRectangle(247,57,266,76,-fill=>'yellow');
$r->createRectangle(247,76,266,95,-fill=>'red');
$r->createRectangle(247,95,266,114,-fill=>'yellow');
$r->createRectangle(247,114,266,133,-fill=>'yellow');
$r->createRectangle(247,133,266,152,-fill=>'yellow');  
$r->createRectangle(247,152,266,171,-fill=>'yellow');  
$r->createRectangle(247,171,266,190,-fill=>'yellow');  
$r->createRectangle(247,190,266,209,-fill=>"#DAA520");  
$r->createRectangle(247,209,266,228,-fill=>"#DAA520");  
$r->createRectangle(247,228,266,247,-fill=>"#DAA520");  
$r->createRectangle(247,247,266,266,-fill=>"#DAA520");  
$r->createRectangle(247,266,266,285,-fill=>"#DAA520");  
$r->createRectangle(247,285,266,304,-fill=>"#DAA520");  
$r->createRectangle(247,304,266,323,-fill=>"#DAA520");  
$r->createRectangle(247,323,266,342,-fill=>'yellow');  
$r->createRectangle(247,342,266,361,-fill=>'yellow');
$r->createRectangle(247,361,266,380,-fill=>'yellow');
$r->createRectangle(247,380,266,399,-fill=>'red');
$r->createRectangle(247,399,266,418,-fill=>'red');
$r->createRectangle(247,418,266,437,-fill=>'red');
$r->createRectangle(247,437,266,456,-fill=>'red');
$r->createRectangle(247,456,266,475,-fill=>'red');
$r->createRectangle(247,475,266,494,-fill=>'yellow');
$r->createRectangle(247,494,266,513,-fill=>'yellow');
$r->createRectangle(247,513,266,532,-fill=>'yellow');
$r->createRectangle(247,532,266,551,-fill=>"#DAA520");
$r->createRectangle(247,551,266,570,-fill=>"#DAA520");
$r->createRectangle(247,570,266,589,-fill=>"#DAA520");
$r->createRectangle(247,589,266,608,-fill=>"#DAA520");
$r->createRectangle(247,608,266,627,-fill=>"#DAA520");
$r->createRectangle(247,627,266,646,-fill=>"#DAA520");
$r->createRectangle(247,646,266,665,-fill=>"#DAA520");
$r->createRectangle(247,665,266,684,-fill=>"#DAA520");
#i=15;
$r->createRectangle(266,0,285,19,-fill=>"#DAA520");
$r->createRectangle(266,19,285,38,-fill=>'yellow');
$r->createRectangle(266,38,285,57,-fill=>'yellow');
$r->createRectangle(266,57,285,76,-fill=>'yellow');
$r->createRectangle(266,76,285,95,-fill=>'yellow');
$r->createRectangle(266,95,285,114,-fill=>'yellow');
$r->createRectangle(266,114,285,133,-fill=>'yellow');
$r->createRectangle(266,133,285,152,-fill=>'yellow');
$r->createRectangle(266,152,285,171,-fill=>'yellow');
$r->createRectangle(266,171,285,190,-fill=>"#DAA520");
$r->createRectangle(266,190,285,209,-fill=>"#DAA520");
$r->createRectangle(266,209,285,228,-fill=>"#DAA520");
$r->createRectangle(266,228,285,247,-fill=>"#DAA520");
$r->createRectangle(266,247,285,266,-fill=>"#DAA520");
$r->createRectangle(266,266,285,285,-fill=>"#DAA520");
$r->createRectangle(266,285,285,304,-fill=>"#DAA520");
$r->createRectangle(266,304,285,323,-fill=>"#DAA520");
$r->createRectangle(266,323,285,342,-fill=>"#DAA520");
$r->createRectangle(266,342,285,361,-fill=>'yellow');
$r->createRectangle(266,361,285,380,-fill=>'yellow');
$r->createRectangle(266,380,285,399,-fill=>'yellow');
$r->createRectangle(266,399,285,418,-fill=>'yellow');
$r->createRectangle(266,418,285,437,-fill=>'red');
$r->createRectangle(266,437,285,456,-fill=>'red');
$r->createRectangle(266,456,285,475,-fill=>'red');
$r->createRectangle(266,475,285,494,-fill=>'yellow');
$r->createRectangle(266,494,285,513,-fill=>'yellow');
$r->createRectangle(266,513,285,532,-fill=>'yellow');
$r->createRectangle(266,532,285,551,-fill=>"#DAA520");
$r->createRectangle(266,551,285,570,-fill=>"#DAA520");
$r->createRectangle(266,570,285,589,-fill=>'white');
$r->createRectangle(266,589,285,608,-fill=>'white');
$r->createRectangle(266,608,285,627,-fill=>"#DAA520");
$r->createRectangle(266,627,285,646,-fill=>"#DAA520");
$r->createRectangle(266,646,285,665,-fill=>"#DAA520");
$r->createRectangle(266,665,285,684,-fill=>"#DAA520");
#i=16;
$r->createRectangle(285,0,304,19,-fill=>"#DAA520");
$r->createRectangle(285,19,304,38,-fill=>"#DAA520");
$r->createRectangle(285,38,304,57,-fill=>"#DAA520");
$r->createRectangle(285,57,304,76,-fill=>'yellow');
$r->createRectangle(285,76,304,95,-fill=>'yellow');
$r->createRectangle(285,95,304,114,-fill=>'yellow');
$r->createRectangle(285,114,304,133,-fill=>'yellow');
$r->createRectangle(285,133,304,152,-fill=>'yellow');
$r->createRectangle(285,152,304,171,-fill=>'yellow');
$r->createRectangle(285,171,304,190,-fill=>"#DAA520");
$r->createRectangle(285,190,304,209,-fill=>"#DAA520");
$r->createRectangle(285,209,304,228,-fill=>'white');
$r->createRectangle(285,228,304,247,-fill=>'white');
$r->createRectangle(285,247,304,266,-fill=>'white');
$r->createRectangle(285,266,304,285,-fill=>'white');
$r->createRectangle(285,285,304,304,-fill=>"#DAA520");
$r->createRectangle(285,304,304,323,-fill=>"#DAA520");
$r->createRectangle(285,323,304,342,-fill=>"#DAA520");
$r->createRectangle(285,342,304,361,-fill=>"#DAA520");
$r->createRectangle(285,361,304,380,-fill=>"#DAA520");
$r->createRectangle(285,380,304,399,-fill=>'yellow');
$r->createRectangle(285,399,304,418,-fill=>'yellow');
$r->createRectangle(285,418,304,437,-fill=>'yellow');
$r->createRectangle(285,437,304,456,-fill=>'yellow');
$r->createRectangle(285,456,304,475,-fill=>'yellow');
$r->createRectangle(285,475,304,494,-fill=>'yellow');
$r->createRectangle(285,494,304,513,-fill=>'yellow');
$r->createRectangle(285,513,304,532,-fill=>"#DAA520");
$r->createRectangle(285,532,304,551,-fill=>"#DAA520");
$r->createRectangle(285,551,304,570,-fill=>"#DAA520");
$r->createRectangle(285,570,304,589,-fill=>'white');
$r->createRectangle(285,589,304,608,-fill=>'white');
$r->createRectangle(285,608,304,627,-fill=>'white');
$r->createRectangle(285,627,304,646,-fill=>'white');
$r->createRectangle(285,646,304,665,-fill=>'white');
$r->createRectangle(285,665,304,684,-fill=>'white');
#i=17;
$r->createRectangle(304,0,323,19,-fill=>'white');
$r->createRectangle(304,19,323,38,-fill=>"#DAA520");
$r->createRectangle(304,38,323,57,-fill=>"#DAA520");
$r->createRectangle(304,57,323,76,-fill=>'yellow');
$r->createRectangle(304,76,323,95,-fill=>"#DAA520");
$r->createRectangle(304,95,323,114,-fill=>"#DAA520");
$r->createRectangle(304,114,323,133,-fill=>"#DAA520");
$r->createRectangle(304,133,323,152,-fill=>'yellow');
$r->createRectangle(304,152,323,171,-fill=>'yellow');
$r->createRectangle(304,171,323,190,-fill=>"#DAA520");
$r->createRectangle(304,190,323,209,-fill=>"#DAA520");
$r->createRectangle(304,209,323,228,-fill=>'white');
$r->createRectangle(304,228,323,247,-fill=>'white');
$r->createRectangle(304,247,323,266,-fill=>'white');
$r->createRectangle(304,266,323,285,-fill=>'white');
$r->createRectangle(304,285,323,304,-fill=>'white');
$r->createRectangle(304,304,323,323,-fill=>"#DAA520");
$r->createRectangle(304,323,323,342,-fill=>"#DAA520");
$r->createRectangle(304,342,323,361,-fill=>"#DAA520");
$r->createRectangle(304,361,323,380,-fill=>"#DAA520");
$r->createRectangle(304,380,323,399,-fill=>"#DAA520");
$r->createRectangle(304,399,323,418,-fill=>'yellow');
$r->createRectangle(304,418,323,437,-fill=>'yellow');
$r->createRectangle(304,437,323,456,-fill=>'yellow');
$r->createRectangle(304,456,323,475,-fill=>'yellow');
$r->createRectangle(304,475,323,494,-fill=>'yellow');
$r->createRectangle(304,494,323,513,-fill=>'yellow');
$r->createRectangle(304,513,323,532,-fill=>"#DAA520");
$r->createRectangle(304,532,323,551,-fill=>"#DAA520");
$r->createRectangle(304,551,323,570,-fill=>"#DAA520");
$r->createRectangle(304,570,323,589,-fill=>'white');
$r->createRectangle(304,589,323,608,-fill=>'white');
$r->createRectangle(304,608,323,627,-fill=>'white');
$r->createRectangle(304,627,323,646,-fill=>'white');
$r->createRectangle(304,646,323,665,-fill=>'white');
$r->createRectangle(304,665,323,684,-fill=>'white');
#i=18;
$r->createRectangle(323,0,342,19,-fill=>'white');
$r->createRectangle(323,19,342,38,-fill=>'white');
$r->createRectangle(323,38,342,57,-fill=>"#DAA520");
$r->createRectangle(323,57,342,76,-fill=>"#DAA520");
$r->createRectangle(323,76,342,95,-fill=>"#DAA520");
$r->createRectangle(323,95,342,114,-fill=>"#DAA520");
$r->createRectangle(323,114,342,133,-fill=>"#DAA520");
$r->createRectangle(323,133,342,152,-fill=>"#DAA520");
$r->createRectangle(323,152,342,171,-fill=>"#DAA520");
$r->createRectangle(323,171,342,190,-fill=>"#DAA520");
$r->createRectangle(323,190,342,209,-fill=>"#DAA520");
$r->createRectangle(323,209,342,228,-fill=>'white');
$r->createRectangle(323,228,342,247,-fill=>'white');
$r->createRectangle(323,247,342,266,-fill=>'white');
$r->createRectangle(323,266,342,285,-fill=>'white');
$r->createRectangle(323,285,342,304,-fill=>'white');
$r->createRectangle(323,304,342,323,-fill=>'white');
$r->createRectangle(323,323,342,342,-fill=>'white');
$r->createRectangle(323,342,342,361,-fill=>'white');
$r->createRectangle(323,361,342,380,-fill=>"#DAA520");
$r->createRectangle(323,380,342,399,-fill=>"#DAA520");
$r->createRectangle(323,399,342,418,-fill=>"#DAA520");
$r->createRectangle(323,418,342,437,-fill=>"#DAA520");
$r->createRectangle(323,437,342,456,-fill=>"#DAA520");
$r->createRectangle(323,456,342,475,-fill=>"#DAA520");
$r->createRectangle(323,475,342,494,-fill=>'yellow');
$r->createRectangle(323,494,342,513,-fill=>"#DAA520");
$r->createRectangle(323,513,342,532,-fill=>"#DAA520");
$r->createRectangle(323,532,342,551,-fill=>"#DAA520");
$r->createRectangle(323,551,342,570,-fill=>'white');
$r->createRectangle(323,570,342,589,-fill=>'white');
$r->createRectangle(323,589,342,608,-fill=>'white');
$r->createRectangle(323,608,342,627,-fill=>'white');
$r->createRectangle(323,627,342,646,-fill=>'white');
$r->createRectangle(323,646,342,665,-fill=>'white');
$r->createRectangle(323,665,342,684,-fill=>'white');
#i=19;
$r->createRectangle(342,0,361,19,-fill=>'white');
$r->createRectangle(342,19,361,38,-fill=>'white');
$r->createRectangle(342,38,361,57,-fill=>"#DAA520");
$r->createRectangle(342,57,361,76,-fill=>"#DAA520");
$r->createRectangle(342,76,361,95,-fill=>"#DAA520");
$r->createRectangle(342,95,361,114,-fill=>"#DAA520");
$r->createRectangle(342,114,361,133,-fill=>"#DAA520");
$r->createRectangle(342,133,361,152,-fill=>"#DAA520");
$r->createRectangle(342,152,361,171,-fill=>"#DAA520");
$r->createRectangle(342,171,361,190,-fill=>"#DAA520");
$r->createRectangle(342,190,361,209,-fill=>"#DAA520");
$r->createRectangle(342,209,361,228,-fill=>'white');
$r->createRectangle(342,228,361,247,-fill=>'white');
$r->createRectangle(342,247,361,266,-fill=>'white');
$r->createRectangle(342,266,361,285,-fill=>'white');
$r->createRectangle(342,285,361,304,-fill=>'white');
$r->createRectangle(342,304,361,323,-fill=>'white');
$r->createRectangle(342,323,361,342,-fill=>'white');
$r->createRectangle(342,342,361,361,-fill=>'white');
$r->createRectangle(342,361,361,380,-fill=>"#DAA520");
$r->createRectangle(342,380,361,399,-fill=>"#DAA520");
$r->createRectangle(342,399,361,418,-fill=>"#DAA520");
$r->createRectangle(342,418,361,437,-fill=>"#DAA520");
$r->createRectangle(342,437,361,456,-fill=>"#DAA520");
$r->createRectangle(342,456,361,475,-fill=>"#DAA520");
$r->createRectangle(342,475,361,494,-fill=>'yellow');
$r->createRectangle(342,494,361,513,-fill=>"#DAA520");
$r->createRectangle(342,513,361,532,-fill=>"#DAA520");
$r->createRectangle(342,532,361,551,-fill=>"#DAA520");
$r->createRectangle(342,551,361,570,-fill=>'white');
$r->createRectangle(342,570,361,589,-fill=>'white');
$r->createRectangle(342,589,361,608,-fill=>'white');
$r->createRectangle(342,608,361,627,-fill=>'white');
$r->createRectangle(342,627,361,646,-fill=>'white');
$r->createRectangle(342,646,361,665,-fill=>'white');
$r->createRectangle(342,665,361,684,-fill=>'white');
#i=20;
$r->createRectangle(361,0,380,19,-fill=>'white');
$r->createRectangle(361,19,380,38,-fill=>'white');
$r->createRectangle(361,38,380,57,-fill=>'white');
$r->createRectangle(361,57,380,76,-fill=>'white');
$r->createRectangle(361,76,380,95,-fill=>'white');
$r->createRectangle(361,95,380,114,-fill=>'white');
$r->createRectangle(361,114,380,133,-fill=>'white');
$r->createRectangle(361,133,380,152,-fill=>"#DAA520");
$r->createRectangle(361,152,380,171,-fill=>"#DAA520");
$r->createRectangle(361,171,380,190,-fill=>"#DAA520");
$r->createRectangle(361,190,380,209,-fill=>"#DAA520");
$r->createRectangle(361,209,380,228,-fill=>"#DAA520");
$r->createRectangle(361,228,380,247,-fill=>"#DAA520");
$r->createRectangle(361,247,380,266,-fill=>"#DAA520");
$r->createRectangle(361,266,380,285,-fill=>"#DAA520");
$r->createRectangle(361,285,380,304,-fill=>"#DAA520");
$r->createRectangle(361,304,380,323,-fill=>'white');
$r->createRectangle(361,323,380,342,-fill=>'white');
$r->createRectangle(361,342,380,361,-fill=>'white');
$r->createRectangle(361,361,380,380,-fill=>'white');
$r->createRectangle(361,380,380,399,-fill=>'white');
$r->createRectangle(361,399,380,418,-fill=>"#DAA520");
$r->createRectangle(361,418,380,437,-fill=>"#DAA520");
$r->createRectangle(361,437,380,456,-fill=>"#DAA520");
$r->createRectangle(361,456,380,475,-fill=>"#DAA520");
$r->createRectangle(361,475,380,494,-fill=>"#DAA520");
$r->createRectangle(361,494,380,513,-fill=>"#DAA520");
$r->createRectangle(361,513,380,532,-fill=>"#DAA520");
$r->createRectangle(361,532,380,551,-fill=>"#DAA520");
$r->createRectangle(361,551,380,570,-fill=>'white');
$r->createRectangle(361,570,380,589,-fill=>'white');
$r->createRectangle(361,589,380,608,-fill=>'white');
$r->createRectangle(361,608,380,627,-fill=>'white');
$r->createRectangle(361,627,380,646,-fill=>'white');
$r->createRectangle(361,646,380,665,-fill=>'white');
$r->createRectangle(361,665,380,684,-fill=>'white');
#i=21;
$r->createRectangle(380,0,399,19,-fill=>"#DAA520");
$r->createRectangle(380,19,399,38,-fill=>'white');
$r->createRectangle(380,38,399,57,-fill=>'white');
$r->createRectangle(380,57,399,76,-fill=>'white');
$r->createRectangle(380,76,399,95,-fill=>'white');
$r->createRectangle(380,95,399,114,-fill=>'white');
$r->createRectangle(380,114,399,133,-fill=>'white');
$r->createRectangle(380,133,399,152,-fill=>"#DAA520");
$r->createRectangle(380,152,399,171,-fill=>"#DAA520");
$r->createRectangle(380,171,399,190,-fill=>"#DAA520");
$r->createRectangle(380,190,399,209,-fill=>"#DAA520");
$r->createRectangle(380,209,399,228,-fill=>"#DAA520");
$r->createRectangle(380,228,399,247,-fill=>"#DAA520");
$r->createRectangle(380,247,399,266,-fill=>"#DAA520");
$r->createRectangle(380,266,399,285,-fill=>"#DAA520");
$r->createRectangle(380,285,399,304,-fill=>"#DAA520");
$r->createRectangle(380,304,399,323,-fill=>"#DAA520");
$r->createRectangle(380,323,399,342,-fill=>"#DAA520");
$r->createRectangle(380,342,399,361,-fill=>"#DAA520");
$r->createRectangle(380,361,399,380,-fill=>"#DAA520");
$r->createRectangle(380,380,399,399,-fill=>"#DAA520");
$r->createRectangle(380,399,399,418,-fill=>'white');
$r->createRectangle(380,418,399,437,-fill=>'white');
$r->createRectangle(380,437,399,456,-fill=>"#DAA520");
$r->createRectangle(380,456,399,475,-fill=>"#DAA520");
$r->createRectangle(380,475,399,494,-fill=>"#DAA520");
$r->createRectangle(380,494,399,513,-fill=>"#DAA520");
$r->createRectangle(380,513,399,532,-fill=>"#DAA520");
$r->createRectangle(380,532,399,551,-fill=>'white');
$r->createRectangle(380,551,399,570,-fill=>'white');
$r->createRectangle(380,570,399,589,-fill=>'white');
$r->createRectangle(380,589,399,608,-fill=>'white');
$r->createRectangle(380,608,399,627,-fill=>'white');
$r->createRectangle(380,627,399,646,-fill=>'white');
$r->createRectangle(380,646,399,665,-fill=>'white');
$r->createRectangle(380,665,399,684,-fill=>'white');
#i=22;
$r->createRectangle(399,0,418,19,-fill=>"#DAA520");
$r->createRectangle(399,19,418,38,-fill=>'white');
$r->createRectangle(399,38,418,57,-fill=>'white');
$r->createRectangle(399,57,418,76,-fill=>'white');
$r->createRectangle(399,76,418,95,-fill=>'white');
$r->createRectangle(399,95,418,114,-fill=>'white');
$r->createRectangle(399,114,418,133,-fill=>'white');
$r->createRectangle(399,133,418,152,-fill=>"#DAA520");
$r->createRectangle(399,152,418,171,-fill=>"#DAA520");
$r->createRectangle(399,171,418,190,-fill=>'yellow');
$r->createRectangle(399,190,418,209,-fill=>'yellow');
$r->createRectangle(399,209,418,228,-fill=>"#DAA520");
$r->createRectangle(399,228,418,247,-fill=>'yellow');
$r->createRectangle(399,247,418,266,-fill=>'yellow');
$r->createRectangle(399,266,418,285,-fill=>"#DAA520");
$r->createRectangle(399,285,418,304,-fill=>"#DAA520");
$r->createRectangle(399,304,418,323,-fill=>"#DAA520");
$r->createRectangle(399,323,418,342,-fill=>"#DAA520");
$r->createRectangle(399,342,418,361,-fill=>"#DAA520");
$r->createRectangle(399,361,418,380,-fill=>"#DAA520");
$r->createRectangle(399,380,418,399,-fill=>"#DAA520");
$r->createRectangle(399,399,418,418,-fill=>'white');
$r->createRectangle(399,418,418,437,-fill=>'white');
$r->createRectangle(399,437,418,456,-fill=>'white');
$r->createRectangle(399,456,418,475,-fill=>'white');
$r->createRectangle(399,475,418,494,-fill=>'white');
$r->createRectangle(399,494,418,513,-fill=>'white');
$r->createRectangle(399,513,418,532,-fill=>'white');
$r->createRectangle(399,532,418,551,-fill=>'white');
$r->createRectangle(399,551,418,579,-fill=>"#DAA520");
$r->createRectangle(399,570,418,589,-fill=>"#DAA520");
$r->createRectangle(399,589,418,608,-fill=>"#DAA520");
$r->createRectangle(399,608,418,627,-fill=>"#DAA520");
$r->createRectangle(399,627,418,646,-fill=>"#DAA520");
$r->createRectangle(399,646,418,665,-fill=>"#DAA520");
$r->createRectangle(399,665,418,684,-fill=>"#DAA520");
#i=23;
$r->createRectangle(418,0,437,19,-fill=>"#DAA520");
$r->createRectangle(418,19,437,38,-fill=>'white');
$r->createRectangle(418,38,437,57,-fill=>'white');
$r->createRectangle(418,57,437,76,-fill=>'white');
$r->createRectangle(418,76,437,95,-fill=>'white');
$r->createRectangle(418,95,437,114,-fill=>'white');
$r->createRectangle(418,114,437,133,-fill=>"#DAA520");
$r->createRectangle(418,133,437,152,-fill=>"#DAA520");
$r->createRectangle(418,152,437,171,-fill=>"#DAA520");
$r->createRectangle(418,171,437,190,-fill=>'yellow');
$r->createRectangle(418,190,437,209,-fill=>'yellow');
$r->createRectangle(418,209,437,228,-fill=>'yellow');
$r->createRectangle(418,228,437,247,-fill=>'yellow');
$r->createRectangle(418,247,437,266,-fill=>'yellow');
$r->createRectangle(418,266,437,285,-fill=>'yellow');
$r->createRectangle(418,285,437,304,-fill=>'yellow');
$r->createRectangle(418,304,437,323,-fill=>"#DAA520");
$r->createRectangle(418,323,437,342,-fill=>"#DAA520");
$r->createRectangle(418,342,437,361,-fill=>"#DAA520");
$r->createRectangle(418,361,437,380,-fill=>"#DAA520");
$r->createRectangle(418,380,437,399,-fill=>"#DAA520");
$r->createRectangle(418,399,437,418,-fill=>'white');
$r->createRectangle(418,418,437,437,-fill=>'white');
$r->createRectangle(418,437,437,456,-fill=>'white');
$r->createRectangle(418,456,437,475,-fill=>'white');
$r->createRectangle(418,475,437,494,-fill=>'white');
$r->createRectangle(418,494,437,513,-fill=>'white');
$r->createRectangle(418,513,437,532,-fill=>'white');
$r->createRectangle(418,532,437,551,-fill=>'white');
$r->createRectangle(418,551,437,570,-fill=>'white');
$r->createRectangle(418,570,437,589,-fill=>"#DAA520");
$r->createRectangle(418,589,437,608,-fill=>"#DAA520");
$r->createRectangle(418,608,437,627,-fill=>"#DAA520");
$r->createRectangle(418,627,437,646,-fill=>"#DAA520");
$r->createRectangle(418,646,437,665,-fill=>"#DAA520");
$r->createRectangle(418,665,437,684,-fill=>"#DAA520");
#i=24;
$r->createRectangle(437,0,456,19,-fill=>"#DAA520");
$r->createRectangle(437,19,456,38,-fill=>'white');
$r->createRectangle(437,38,456,57,-fill=>'white');
$r->createRectangle(437,57,456,76,-fill=>'white');
$r->createRectangle(437,76,456,95,-fill=>'white');
$r->createRectangle(437,95,456,114,-fill=>'white');
$r->createRectangle(437,114,456,133,-fill=>"#DAA520");
$r->createRectangle(437,133,456,152,-fill=>"#DAA520");
$r->createRectangle(437,152,456,171,-fill=>"#DAA520");
$r->createRectangle(437,171,456,190,-fill=>'yellow');
$r->createRectangle(437,190,456,209,-fill=>'yellow');
$r->createRectangle(437,209,456,228,-fill=>'yellow');
$r->createRectangle(437,228,456,247,-fill=>'yellow');
$r->createRectangle(437,247,456,266,-fill=>'red');
$r->createRectangle(437,266,456,285,-fill=>'red');
$r->createRectangle(437,285,456,304,-fill=>'yellow');
$r->createRectangle(437,304,456,323,-fill=>'yellow');
$r->createRectangle(437,323,456,342,-fill=>"#DAA520");
$r->createRectangle(437,342,456,361,-fill=>'yellow');
$r->createRectangle(437,361,456,380,-fill=>"#DAA520");
$r->createRectangle(437,380,456,399,-fill=>"#DAA520");
$r->createRectangle(437,399,456,418,-fill=>'white');
$r->createRectangle(437,418,456,437,-fill=>'white');
$r->createRectangle(437,437,456,456,-fill=>'white');
$r->createRectangle(437,456,456,475,-fill=>'white');
$r->createRectangle(437,475,456,494,-fill=>'white');
$r->createRectangle(437,494,456,513,-fill=>'white');
$r->createRectangle(437,513,456,532,-fill=>'white');
$r->createRectangle(437,532,456,551,-fill=>'white');
$r->createRectangle(437,551,456,570,-fill=>'white');
$r->createRectangle(437,570,456,589,-fill=>"#DAA520");
$r->createRectangle(437,589,456,608,-fill=>"#DAA520");
$r->createRectangle(437,608,456,627,-fill=>'yellow');
$r->createRectangle(437,627,456,646,-fill=>'yellow');
$r->createRectangle(437,646,456,665,-fill=>'yellow');
$r->createRectangle(437,665,456,684,-fill=>"#DAA520");
#i=25;
$r->createRectangle(456,0,475,19,-fill=>"#DAA520");
$r->createRectangle(456,19,475,38,-fill=>'white');
$r->createRectangle(456,38,475,57,-fill=>'white');
$r->createRectangle(456,57,475,76,-fill=>'white');
$r->createRectangle(456,76,475,95,-fill=>'white');
$r->createRectangle(456,95,475,114,-fill=>'white');
$r->createRectangle(456,114,475,133,-fill=>"#DAA520");
$r->createRectangle(456,133,475,152,-fill=>"#DAA520");
$r->createRectangle(456,152,475,171,-fill=>'yellow');
$r->createRectangle(456,171,475,290,-fill=>'yellow');
$r->createRectangle(456,190,475,209,-fill=>'yellow');
$r->createRectangle(456,209,475,228,-fill=>'yellow');
$r->createRectangle(456,228,475,247,-fill=>'yellow');
$r->createRectangle(456,247,475,266,-fill=>'yellow');
$r->createRectangle(456,266,475,285,-fill=>'red');
$r->createRectangle(456,285,475,304,-fill=>'yellow');
$r->createRectangle(456,304,475,323,-fill=>'yellow');
$r->createRectangle(456,323,475,342,-fill=>'yellow');
$r->createRectangle(456,342,475,361,-fill=>"#DAA520");
$r->createRectangle(456,361,475,380,-fill=>"#DAA520");
$r->createRectangle(456,380,475,399,-fill=>"#DAA520");
$r->createRectangle(456,399,475,418,-fill=>'white');
$r->createRectangle(456,418,475,437,-fill=>'white');
$r->createRectangle(456,437,475,456,-fill=>'white');
$r->createRectangle(456,456,475,475,-fill=>'white');
$r->createRectangle(456,475,475,494,-fill=>'white');
$r->createRectangle(456,494,475,513,-fill=>'white');
$r->createRectangle(456,513,475,532,-fill=>'white');
$r->createRectangle(456,532,475,551,-fill=>'white');
$r->createRectangle(456,551,475,570,-fill=>'white');
$r->createRectangle(456,570,475,589,-fill=>"#DAA520");
$r->createRectangle(456,589,475,608,-fill=>"#DAA520");
$r->createRectangle(456,608,475,627,-fill=>"#DAA520");
$r->createRectangle(456,627,475,646,-fill=>"#DAA520");
$r->createRectangle(456,646,475,665,-fill=>'yellow');
$r->createRectangle(456,665,475,684,-fill=>"#DAA520");
#i=26;
$r->createRectangle(475,0,494,19,-fill=>"#DAA520");
$r->createRectangle(475,19,494,38,-fill=>'white');
$r->createRectangle(475,38,494,57,-fill=>'white');
$r->createRectangle(475,57,494,76,-fill=>'white');
$r->createRectangle(475,76,494,95,-fill=>'white');
$r->createRectangle(475,95,494,114,-fill=>'white');
$r->createRectangle(475,114,494,133,-fill=>"#DAA520");
$r->createRectangle(475,133,494,152,-fill=>"#DAA520");
$r->createRectangle(475,152,494,171,-fill=>'yellow');
$r->createRectangle(475,171,494,190,-fill=>"#DAA520");
$r->createRectangle(475,190,494,209,-fill=>"#DAA520");
$r->createRectangle(475,209,494,228,-fill=>"#DAA520");
$r->createRectangle(475,228,494,247,-fill=>'yellow');
$r->createRectangle(475,247,494,266,-fill=>'yellow');
$r->createRectangle(475,266,494,285,-fill=>'yellow');
$r->createRectangle(475,285,494,304,-fill=>'yellow');
$r->createRectangle(475,304,494,323,-fill=>'yellow');
$r->createRectangle(475,323,494,342,-fill=>'yellow');
$r->createRectangle(475,342,494,361,-fill=>'yellow');
$r->createRectangle(475,361,494,380,-fill=>"#DAA520");
$r->createRectangle(475,380,494,399,-fill=>"#DAA520");
$r->createRectangle(475,399,494,418,-fill=>'white');
$r->createRectangle(475,418,494,437,-fill=>'white');
$r->createRectangle(475,437,494,456,-fill=>'white');
$r->createRectangle(475,456,494,475,-fill=>'white');
$r->createRectangle(475,475,494,494,-fill=>'white');
$r->createRectangle(475,494,494,513,-fill=>'white');
$r->createRectangle(475,513,494,532,-fill=>'white');
$r->createRectangle(475,532,494,551,-fill=>'white');
$r->createRectangle(475,551,494,570,-fill=>'white');
$r->createRectangle(475,570,494,589,-fill=>"#DAA520");
$r->createRectangle(475,589,494,608,-fill=>"#DAA520");
$r->createRectangle(475,608,494,627,-fill=>"#DAA520");
$r->createRectangle(475,627,494,646,-fill=>"#DAA520");
$r->createRectangle(475,646,494,665,-fill=>"#DAA520");
$r->createRectangle(475,665,494,684,-fill=>"#DAA520");
#i=27;
$r->createRectangle(494,0,513,19,-fill=>'white');
$r->createRectangle(494,19,513,38,-fill=>'white');
$r->createRectangle(494,38,513,57,-fill=>'white');
$r->createRectangle(494,57,513,76,-fill=>'white');
$r->createRectangle(494,76,513,95,-fill=>'white');
$r->createRectangle(494,95,513,114,-fill=>'white');
$r->createRectangle(494,114,513,133,-fill=>"#DAA520");
$r->createRectangle(494,133,513,152,-fill=>"#DAA520");
$r->createRectangle(494,152,513,171,-fill=>"#DAA520");
$r->createRectangle(494,171,513,190,-fill=>"#DAA520");
$r->createRectangle(494,190,513,209,-fill=>"#DAA520");
$r->createRectangle(494,209,513,228,-fill=>"#DAA520");
$r->createRectangle(494,228,513,247,-fill=>'yellow');
$r->createRectangle(494,247,513,266,-fill=>"#DAA520");
$r->createRectangle(494,266,513,285,-fill=>"#DAA520");
$r->createRectangle(494,285,513,304,-fill=>'yellow');
$r->createRectangle(494,304,513,323,-fill=>"#DAA520");
$r->createRectangle(494,323,513,342,-fill=>'yellow');
$r->createRectangle(494,342,513,361,-fill=>'yellow');
$r->createRectangle(494,361,513,380,-fill=>"#DAA520");
$r->createRectangle(494,380,513,399,-fill=>"#DAA520");
$r->createRectangle(494,399,513,418,-fill=>'white');
$r->createRectangle(494,418,513,437,-fill=>'white');
$r->createRectangle(494,437,513,456,-fill=>'white');
$r->createRectangle(494,456,513,475,-fill=>'white');
$r->createRectangle(494,475,513,494,-fill=>'white');
$r->createRectangle(494,494,513,513,-fill=>'white');
$r->createRectangle(494,513,513,532,-fill=>'white');
$r->createRectangle(494,532,513,551,-fill=>'white');
$r->createRectangle(494,551,513,570,-fill=>'white');
$r->createRectangle(494,570,513,589,-fill=>'white');
$r->createRectangle(494,589,513,608,-fill=>'white');
$r->createRectangle(494,608,513,627,-fill=>"#DAA520");
$r->createRectangle(494,627,513,646,-fill=>"#DAA520");
$r->createRectangle(494,646,513,665,-fill=>"#DAA520");
$r->createRectangle(494,665,513,684,-fill=>"#DAA520");
#i=28;
$r->createRectangle(513,0,532,19,-fill=>'white');
$r->createRectangle(513,19,532,38,-fill=>'white');
$r->createRectangle(513,38,532,57,-fill=>'white');
$r->createRectangle(513,57,532,76,-fill=>'white');
$r->createRectangle(513,76,532,95,-fill=>'white');
$r->createRectangle(513,95,532,114,-fill=>'white');
$r->createRectangle(513,114,532,133,-fill=>"#DAA520");
$r->createRectangle(513,133,532,152,-fill=>"#DAA520");
$r->createRectangle(513,152,532,171,-fill=>"#DAA520");
$r->createRectangle(513,171,532,190,-fill=>"#DAA520");
$r->createRectangle(513,190,532,209,-fill=>"#DAA520");
$r->createRectangle(513,209,532,228,-fill=>"#DAA520");
$r->createRectangle(513,228,532,247,-fill=>"#DAA520");
$r->createRectangle(513,247,532,266,-fill=>"#DAA520");
$r->createRectangle(513,266,532,285,-fill=>"#DAA520");
$r->createRectangle(513,285,532,304,-fill=>"#DAA520");
$r->createRectangle(513,304,532,323,-fill=>"#DAA520");
$r->createRectangle(513,323,532,342,-fill=>"#DAA520");
$r->createRectangle(513,342,532,361,-fill=>"#DAA520");
$r->createRectangle(513,361,532,380,-fill=>"#DAA520");
$r->createRectangle(513,380,532,399,-fill=>"#DAA520");
$r->createRectangle(513,399,532,418,-fill=>'white');
$r->createRectangle(513,418,532,437,-fill=>'white');
$r->createRectangle(513,437,532,456,-fill=>'white');
$r->createRectangle(513,456,532,475,-fill=>'white');
$r->createRectangle(513,475,532,494,-fill=>'white');
$r->createRectangle(513,494,532,513,-fill=>'white');
$r->createRectangle(513,513,532,532,-fill=>'white');
$r->createRectangle(513,532,532,551,-fill=>'white');
$r->createRectangle(513,551,532,570,-fill=>'white');
$r->createRectangle(513,570,532,589,-fill=>'white');
$r->createRectangle(513,589,532,608,-fill=>'white');
$r->createRectangle(513,608,532,627,-fill=>'white');
$r->createRectangle(513,627,532,646,-fill=>'white');
$r->createRectangle(513,646,532,665,-fill=>'white');
$r->createRectangle(513,665,532,684,-fill=>'white');
#i=29;
$r->createRectangle(532,0,551,19,-fill=>'white');
$r->createRectangle(532,19,551,38,-fill=>'white');
$r->createRectangle(532,38,551,57,-fill=>'white');
$r->createRectangle(532,57,551,76,-fill=>'white');
$r->createRectangle(532,76,551,95,-fill=>'white');
$r->createRectangle(532,95,551,114,-fill=>'white');
$r->createRectangle(532,114,551,133,-fill=>'white');
$r->createRectangle(532,133,551,152,-fill=>'white');
$r->createRectangle(532,152,551,171,-fill=>'white');
$r->createRectangle(532,171,551,190,-fill=>'white');
$r->createRectangle(532,190,551,209,-fill=>'white');
$r->createRectangle(532,209,551,228,-fill=>"#DAA520");
$r->createRectangle(532,228,551,247,-fill=>"#DAA520");
$r->createRectangle(532,247,551,266,-fill=>"#DAA520");
$r->createRectangle(532,266,551,285,-fill=>"#DAA520");
$r->createRectangle(532,285,551,304,-fill=>"#DAA520");
$r->createRectangle(532,304,551,323,-fill=>"#DAA520");
$r->createRectangle(532,323,551,342,-fill=>"#DAA520");
$r->createRectangle(532,342,551,361,-fill=>"#DAA520");
$r->createRectangle(532,361,551,380,-fill=>"#DAA520");
$r->createRectangle(532,380,551,399,-fill=>"#DAA520");
$r->createRectangle(532,399,551,418,-fill=>'white');
$r->createRectangle(532,418,551,437,-fill=>'white');
$r->createRectangle(532,437,551,456,-fill=>'white');
$r->createRectangle(532,456,551,475,-fill=>'white');
$r->createRectangle(532,475,551,494,-fill=>'white');
$r->createRectangle(532,494,551,513,-fill=>'white');
$r->createRectangle(532,513,551,532,-fill=>'white');
$r->createRectangle(532,532,551,551,-fill=>'white');
$r->createRectangle(532,551,551,570,-fill=>'white');
$r->createRectangle(532,570,551,589,-fill=>'white');
$r->createRectangle(532,589,551,608,-fill=>'white');
$r->createRectangle(532,608,551,627,-fill=>'white');
$r->createRectangle(532,627,551,646,-fill=>'white');
$r->createRectangle(532,646,551,665,-fill=>'white');
$r->createRectangle(532,665,551,684,-fill=>'white');
#i=30;
$r->createRectangle(551,0,570,19,-fill=>'white');
$r->createRectangle(551,19,570,38,-fill=>'white');
$r->createRectangle(551,38,570,57,-fill=>'white');
$r->createRectangle(551,57,570,76,-fill=>'white');
$r->createRectangle(551,76,570,95,-fill=>'white');
$r->createRectangle(551,95,570,114,-fill=>'white');
$r->createRectangle(551,114,570,133,-fill=>'white');
$r->createRectangle(551,133,570,152,-fill=>'white');
$r->createRectangle(551,152,570,171,-fill=>'white');
$r->createRectangle(551,171,570,190,-fill=>'white');
$r->createRectangle(551,190,570,209,-fill=>'white');
$r->createRectangle(551,209,570,228,-fill=>'white');
$r->createRectangle(551,228,570,247,-fill=>'white');
$r->createRectangle(551,247,570,266,-fill=>'white');
$r->createRectangle(551,266,570,285,-fill=>'white');
$r->createRectangle(551,285,570,304,-fill=>'white');
$r->createRectangle(551,304,570,323,-fill=>'white');
$r->createRectangle(551,323,570,342,-fill=>'white');
$r->createRectangle(551,342,570,361,-fill=>'white');
$r->createRectangle(551,361,570,380,-fill=>'white');
$r->createRectangle(551,380,570,399,-fill=>'white');
$r->createRectangle(551,399,570,418,-fill=>'white');
$r->createRectangle(551,418,570,437,-fill=>'white');
$r->createRectangle(551,437,570,456,-fill=>'white');
$r->createRectangle(551,456,570,475,-fill=>'white');
$r->createRectangle(551,475,570,494,-fill=>'white');
$r->createRectangle(551,494,570,513,-fill=>'white');
$r->createRectangle(551,513,570,532,-fill=>'white');
$r->createRectangle(551,532,570,551,-fill=>'white');
$r->createRectangle(551,551,570,570,-fill=>'white');
$r->createRectangle(551,570,570,589,-fill=>'white');
$r->createRectangle(551,589,570,608,-fill=>'white');
$r->createRectangle(551,608,570,627,-fill=>'white');
$r->createRectangle(551,627,570,646,-fill=>'white');
$r->createRectangle(551,646,570,665,-fill=>'white');
$r->createRectangle(551,665,570,684,-fill=>'white');
#i=31;
$r->createRectangle(570,0,589,19,-fill=>'white');
$r->createRectangle(570,19,589,38,-fill=>'white');
$r->createRectangle(570,38,589,57,-fill=>'white');
$r->createRectangle(570,57,589,76,-fill=>'white');
$r->createRectangle(570,76,589,95,-fill=>'white');
$r->createRectangle(570,95,589,114,-fill=>'white');
$r->createRectangle(570,114,589,133,-fill=>'white');
$r->createRectangle(570,133,589,152,-fill=>'white');
$r->createRectangle(570,152,589,171,-fill=>'white');
$r->createRectangle(570,171,589,190,-fill=>'white');
$r->createRectangle(570,190,589,209,-fill=>'white');
$r->createRectangle(570,209,589,228,-fill=>'white');
$r->createRectangle(570,228,589,247,-fill=>'white');
$r->createRectangle(570,247,589,266,-fill=>'white');
$r->createRectangle(570,266,589,285,-fill=>'white');
$r->createRectangle(570,285,589,304,-fill=>'white');
$r->createRectangle(570,304,589,323,-fill=>'white');
$r->createRectangle(570,323,589,342,-fill=>'white');
$r->createRectangle(570,342,589,361,-fill=>'white');
$r->createRectangle(570,361,589,380,-fill=>'white');
$r->createRectangle(570,380,589,399,-fill=>'white');
$r->createRectangle(570,399,589,418,-fill=>'white');
$r->createRectangle(570,418,589,437,-fill=>'white');
$r->createRectangle(570,437,589,456,-fill=>'white');
$r->createRectangle(570,456,589,475,-fill=>'white');
$r->createRectangle(570,475,589,494,-fill=>'white');
$r->createRectangle(570,494,589,513,-fill=>'white');
$r->createRectangle(570,513,589,532,-fill=>'white');
$r->createRectangle(570,532,589,551,-fill=>'white');
$r->createRectangle(570,551,589,570,-fill=>'white');
$r->createRectangle(570,570,589,589,-fill=>'white');
$r->createRectangle(570,589,589,608,-fill=>'white');
$r->createRectangle(570,608,589,627,-fill=>'white');
$r->createRectangle(570,627,589,646,-fill=>'white');
$r->createRectangle(570,646,589,665,-fill=>'white');
$r->createRectangle(570,665,589,684,-fill=>'white');
#i=32;
$r->createRectangle(589,0,608,19,-fill=>"#DAA520");
$r->createRectangle(589,19,608,38,-fill=>"#DAA520");
$r->createRectangle(589,38,608,57,-fill=>"#DAA520");
$r->createRectangle(589,57,608,76,-fill=>"#DAA520");
$r->createRectangle(589,76,608,95,-fill=>"#DAA520");
$r->createRectangle(589,95,608,114,-fill=>'white');
$r->createRectangle(589,114,608,133,-fill=>'white');
$r->createRectangle(589,133,608,152,-fill=>'white');
$r->createRectangle(589,152,608,171,-fill=>'white');
$r->createRectangle(589,171,608,190,-fill=>'white');
$r->createRectangle(589,190,608,209,-fill=>'white');
$r->createRectangle(589,209,608,228,-fill=>'white');
$r->createRectangle(589,228,608,247,-fill=>'white');
$r->createRectangle(589,247,608,266,-fill=>'white');
$r->createRectangle(589,266,608,285,-fill=>'white');
$r->createRectangle(589,285,608,304,-fill=>'white');
$r->createRectangle(589,304,608,323,-fill=>'white');
$r->createRectangle(589,323,608,342,-fill=>'white');
$r->createRectangle(589,342,608,361,-fill=>'white');
$r->createRectangle(589,361,608,380,-fill=>'white');
$r->createRectangle(589,380,608,399,-fill=>'white');
$r->createRectangle(589,399,608,418,-fill=>'white');
$r->createRectangle(589,418,608,437,-fill=>'white');
$r->createRectangle(589,437,608,456,-fill=>'white');
$r->createRectangle(589,456,608,475,-fill=>'white');
$r->createRectangle(589,475,608,494,-fill=>'white');
$r->createRectangle(589,494,608,513,-fill=>'white');
$r->createRectangle(589,513,608,532,-fill=>'white');
$r->createRectangle(589,532,608,551,-fill=>'white');
$r->createRectangle(589,551,608,570,-fill=>'white');
$r->createRectangle(589,570,608,589,-fill=>'white');
$r->createRectangle(589,589,608,608,-fill=>'white');
$r->createRectangle(589,608,608,627,-fill=>'white');
$r->createRectangle(589,627,608,646,-fill=>'white');
$r->createRectangle(589,646,608,665,-fill=>'white');
$r->createRectangle(589,665,608,684,-fill=>'white');
#i=33;
$r->createRectangle(608,0,627,19,-fill=>"#DAA520");
$r->createRectangle(608,19,627,38,-fill=>"#DAA520");
$r->createRectangle(608,38,627,57,-fill=>"#DAA520");
$r->createRectangle(608,57,627,76,-fill=>"#DAA520");
$r->createRectangle(608,76,627,95,-fill=>"#DAA520");
$r->createRectangle(608,95,627,114,-fill=>"#DAA520");
$r->createRectangle(608,114,627,133,-fill=>'white');
$r->createRectangle(608,133,627,152,-fill=>'white');
$r->createRectangle(608,152,627,171,-fill=>'white');
$r->createRectangle(608,171,627,190,-fill=>'white');
$r->createRectangle(608,190,627,209,-fill=>'white');
$r->createRectangle(608,209,627,228,-fill=>'white');
$r->createRectangle(608,228,627,247,-fill=>'white');
$r->createRectangle(608,247,627,266,-fill=>'white');
$r->createRectangle(608,266,627,285,-fill=>'white');
$r->createRectangle(608,285,627,304,-fill=>'white');
$r->createRectangle(608,304,627,323,-fill=>'white');
$r->createRectangle(608,323,627,342,-fill=>'white');
$r->createRectangle(608,342,627,361,-fill=>'white');
$r->createRectangle(608,361,627,380,-fill=>'white');
$r->createRectangle(608,380,627,399,-fill=>'white');
$r->createRectangle(608,399,627,418,-fill=>'white');
$r->createRectangle(608,418,627,437,-fill=>'white');
$r->createRectangle(608,437,627,456,-fill=>'white');
$r->createRectangle(608,456,627,475,-fill=>'white');
$r->createRectangle(608,475,627,494,-fill=>'white');
$r->createRectangle(608,494,627,513,-fill=>'white');
$r->createRectangle(608,513,627,532,-fill=>'white');
$r->createRectangle(608,532,627,551,-fill=>'white');
$r->createRectangle(608,551,627,570,-fill=>'white');
$r->createRectangle(608,570,627,589,-fill=>'white');
$r->createRectangle(608,589,627,608,-fill=>'white');
$r->createRectangle(608,608,627,627,-fill=>'white');
$r->createRectangle(608,627,627,646,-fill=>'white');
$r->createRectangle(608,646,627,665,-fill=>'white');
$r->createRectangle(608,665,627,684,-fill=>'white');
#i=34;
$r->createRectangle(627,0,646,19,-fill=>"#DAA520");
$r->createRectangle(627,19,646,38,-fill=>"#DAA520");
$r->createRectangle(627,38,646,57,-fill=>'yellow');
$r->createRectangle(627,57,646,76,-fill=>"#DAA520");
$r->createRectangle(627,76,646,95,-fill=>"#DAA520");
$r->createRectangle(627,95,646,114,-fill=>"#DAA520");
$r->createRectangle(627,114,646,133,-fill=>"#DAA520");
$r->createRectangle(627,133,646,152,-fill=>"#DAA520");
$r->createRectangle(627,152,646,171,-fill=>"#DAA520");
$r->createRectangle(627,171,646,190,-fill=>"#DAA520");
$r->createRectangle(627,190,646,209,-fill=>"#DAA520");
$r->createRectangle(627,209,646,228,-fill=>"#DAA520");
$r->createRectangle(627,228,646,247,-fill=>"#DAA520");
$r->createRectangle(627,247,646,266,-fill=>"#DAA520");
$r->createRectangle(627,266,646,285,-fill=>"#DAA520");
$r->createRectangle(627,285,646,530,-fill=>"#DAA520");
$r->createRectangle(627,304,646,323,-fill=>"#DAA520");
$r->createRectangle(627,323,646,342,-fill=>"#DAA520");
$r->createRectangle(627,342,646,361,-fill=>"#DAA520");
$r->createRectangle(627,361,646,380,-fill=>"#DAA520");
$r->createRectangle(627,380,646,399,-fill=>"#DAA520");
$r->createRectangle(627,399,646,418,-fill=>"#DAA520");
$r->createRectangle(627,418,646,437,-fill=>"#DAA520");
$r->createRectangle(627,437,646,456,-fill=>"#DAA520");
$r->createRectangle(627,456,646,475,-fill=>"#DAA520");
$r->createRectangle(627,475,646,494,-fill=>"#DAA520");
$r->createRectangle(627,494,646,513,-fill=>"#DAA520");
$r->createRectangle(627,513,646,532,-fill=>'white');
$r->createRectangle(627,532,646,551,-fill=>'white');
$r->createRectangle(627,551,646,570,-fill=>'white');
$r->createRectangle(627,570,646,589,-fill=>'white');
$r->createRectangle(627,589,646,608,-fill=>'white');
$r->createRectangle(627,608,646,627,-fill=>'white');
$r->createRectangle(627,627,646,646,-fill=>"#DAA520");
$r->createRectangle(627,646,646,665,-fill=>"#DAA520");
$r->createRectangle(627,665,646,684,-fill=>"#DAA520");
#i=35;
$r->createRectangle(646,0,665,19,-fill=>"#DAA520");
$r->createRectangle(646,19,665,38,-fill=>'yellow');
$r->createRectangle(646,38,665,57,-fill=>'yellow');
$r->createRectangle(646,57,665,76,-fill=>'yellow');
$r->createRectangle(646,76,665,95,-fill=>"#DAA520");
$r->createRectangle(646,95,665,114,-fill=>"#DAA520");
$r->createRectangle(646,114,665,133,-fill=>"#DAA520");
$r->createRectangle(646,133,665,152,-fill=>"#DAA520");
$r->createRectangle(646,152,665,171,-fill=>"#DAA520");
$r->createRectangle(646,171,665,190,-fill=>"#DAA520");
$r->createRectangle(646,190,665,209,-fill=>"#DAA520");
$r->createRectangle(646,209,665,228,-fill=>"#DAA520");
$r->createRectangle(646,228,665,247,-fill=>"#DAA520");
$r->createRectangle(646,247,665,266,-fill=>"#DAA520");
$r->createRectangle(646,266,665,285,-fill=>"#DAA520");
$r->createRectangle(646,285,665,304,-fill=>"#DAA520");
$r->createRectangle(646,304,665,323,-fill=>"#DAA520");
$r->createRectangle(646,323,665,342,-fill=>"#DAA520");
$r->createRectangle(646,342,665,361,-fill=>"#DAA520");
$r->createRectangle(646,361,665,380,-fill=>"#DAA520");
$r->createRectangle(646,380,665,399,-fill=>"#DAA520");
$r->createRectangle(646,399,665,418,-fill=>"#DAA520");
$r->createRectangle(646,418,665,437,-fill=>"#DAA520");
$r->createRectangle(646,437,665,456,-fill=>"#DAA520");
$r->createRectangle(646,456,665,475,-fill=>"#DAA520");
$r->createRectangle(646,475,665,494,-fill=>"#DAA520");
$r->createRectangle(646,494,665,513,-fill=>"#DAA520");
$r->createRectangle(646,513,665,532,-fill=>'white');
$r->createRectangle(646,532,665,551,-fill=>'white');
$r->createRectangle(646,551,665,570,-fill=>'white');
$r->createRectangle(646,570,665,589,-fill=>'white');
$r->createRectangle(646,589,665,608,-fill=>'white');
$r->createRectangle(646,608,665,627,-fill=>'white');
$r->createRectangle(646,627,665,646,-fill=>"#DAA520");
$r->createRectangle(646,646,665,665,-fill=>"#DAA520");
$r->createRectangle(646,665,665,684,-fill=>"#DAA520");
#$i=36;
$r->createRectangle(665,0,684,19,-fill=>'yellow');
$r->createRectangle(665,19,684,38,-fill=>'yellow');
$r->createRectangle(665,38,684,57,-fill=>'yellow');
$r->createRectangle(665,57,684,76,-fill=>'yellow');
$r->createRectangle(665,76,684,95,-fill=>'yellow');
$r->createRectangle(665,95,684,114,-fill=>'yellow');
$r->createRectangle(665,114,684,133,-fill=>'yellow');
$r->createRectangle(665,133,684,152,-fill=>'yellow');
$r->createRectangle(665,152,684,171,-fill=>'yellow');
$r->createRectangle(665,171,684,190,-fill=>"#DAA520");
$r->createRectangle(665,190,684,209,-fill=>"#DAA520");
$r->createRectangle(665,209,684,228,-fill=>"#DAA520");
$r->createRectangle(665,228,684,247,-fill=>"#DAA520");
$r->createRectangle(665,247,684,266,-fill=>"#DAA520");
$r->createRectangle(665,266,684,285,-fill=>"#DAA520");
$r->createRectangle(665,285,684,304,-fill=>"#DAA520");
$r->createRectangle(665,304,684,323,-fill=>"#DAA520");
$r->createRectangle(665,323,684,342,-fill=>"#DAA520");
$r->createRectangle(665,342,684,361,-fill=>"#DAA520");
$r->createRectangle(665,361,684,380,-fill=>"#DAA520");
$r->createRectangle(665,380,684,399,-fill=>"#DAA520");
$r->createRectangle(665,399,684,418,-fill=>"#DAA520");
$r->createRectangle(665,418,684,437,-fill=>"#DAA520");
$r->createRectangle(665,437,684,456,-fill=>"#DAA520");
$r->createRectangle(665,456,684,475,-fill=>"#DAA520");
$r->createRectangle(665,475,684,494,-fill=>"#DAA520");
$r->createRectangle(665,494,684,513,-fill=>"#DAA520");
$r->createRectangle(665,513,684,532,-fill=>'white');
$r->createRectangle(665,532,684,551,-fill=>'white');
$r->createRectangle(665,551,684,570,-fill=>'white');
$r->createRectangle(665,570,684,589,-fill=>'white');
$r->createRectangle(665,589,684,608,-fill=>'white');
$r->createRectangle(665,608,684,627,-fill=>'white');
$r->createRectangle(665,627,684,646,-fill=>"#DAA520");
$r->createRectangle(665,646,684,665,-fill=>"#DAA520");
$r->createRectangle(665,665,684,684,-fill=>'yellow');
$r->createText(10,10,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(670,670,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(15,670,-fill =>'black',-text =>"-180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(343,670,-fill =>'black',-text =>"Phi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(40,343,-fill =>'black',-text =>"Psi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
open(FH,$m);
@rn=();@nx=();@ny=();@nz=();@rca=();@cax=();@cay=();@caz=();@rc=();@cx=();@cy=();@cz=();
$nc=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ram)
{
if(substr($_,13,3) eq 'N  ')
{
$nc++;
push(@rn,substr($_,23,3));
push(@nx,substr($_,31,7));
push(@ny,substr($_,39,7));
push(@nz,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rca,substr($_,23,3));
push(@cax,substr($_,31,7));
push(@cay,substr($_,39,7));
push(@caz,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rc,substr($_,23,3));
push(@cx,substr($_,31,7));
push(@cy,substr($_,39,7));
push(@cz,substr($_,47,7));
}
}
}
}
@v1x=();@v1y=();@v1z=();
@v2x=();@v2y=();@v2z=();
@v3x=();@v3y=();@v3z=();
for($i=1;$i<$nc;$i++)
{
push(@v1x,$nx[$i]-$cx[$i-1]);
push(@v1y,$ny[$i]-$cy[$i-1]);
push(@v1z,$nz[$i]-$cz[$i-1]);
push(@v2x,$cax[$i]-$nx[$i]);
push(@v2y,$cay[$i]-$ny[$i]);
push(@v2z,$caz[$i]-$nz[$i]);
push(@v3x,$cx[$i]-$cax[$i]);
push(@v3y,$cy[$i]-$cay[$i]);
push(@v3z,$cz[$i]-$caz[$i]);
}
@pyz=();@pxz=();@pxy=();
@qyz=();@qxz=();@qxy=();
for($i=0;$i<$nc;$i++)
{
push(@pyz,$v1y[$i]*$v2z[$i]-$v1z[$i]*$v2y[$i]);
push(@pxz,$v1z[$i]*$v2x[$i]-$v1x[$i]*$v2z[$i]);
push(@pxy,$v1x[$i]*$v2y[$i]-$v1y[$i]*$v2x[$i]);
push(@qyz,$v2y[$i]*$v3z[$i]-$v2z[$i]*$v3y[$i]);
push(@qxz,$v2z[$i]*$v3x[$i]-$v2x[$i]*$v3z[$i]);
push(@qxy,$v2x[$i]*$v3y[$i]-$v2y[$i]*$v3x[$i]);
}
@r1=();@r2=();@r3=();
for($i=0;$i<$nc;$i++)
{
push(@r1,$pzx[$i]*$qxy[$i]-$pxy[$i]*$qzx[$i]);
push(@r2,$pxy[$i]*$qyz[$i]-$pyz[$i]*$qxy[$i]);
push(@r3,$pyz[$i]*$qzx[$i]-$pzx[$i]*$qyz[$i]);
}
@l=();@lp=();@lq=();@cosval=();@sinval=();@angle=();
for($i=0;$i<$nc-1;$i++)
{
$sum[$i]=$pyz[$i]*$qyz[$i]+$pxz[$i]*$qxz[$i]+$pxy[$i]*$qxy[$i];
$lp[$i]=sqrt($pyz[$i]*$pyz[$i]+$pxz[$i]*$pxz[$i]+$pxy[$i]*$pxy[$i]);
$lq[$i]=sqrt($qyz[$i]*$qyz[$i]+$qxz[$i]*$qxz[$i]+$qxy[$i]*$qxy[$i]);
$l[$i]=$lp[$i]*$lq[$i];
}
for($i=0;$i<$nc-1;$i++)
{
$cosval[$i]+=$sum[$i]/$l[$i];
$sinsqval[$i]=1-($cosval[$i]*$cosval[$i]);
if($sinsqval[$i]<0)
{
$sinsqval[$i]=0;
}
$sinval[$i]=sqrt($sinsqval[$i]);
$angle[$i]=-(atan2($sinval[$i],$cosval[$i])*57.29578);
}
@sum1=();
for($i=0;$i<$nc-1;$i++)
{
$sum1[$i]=$r1[$i]*$v2x[$i]+$r2[$i]*$v2y[$i]+$r3[$i]*$v3z[$i];
if($sum1[$i] > 0)
{
$angle[$i] = -$angle[$i];
}
}

my $top_ram= $subframe2_ram;
my $arrayVar = {};
my ($rows,$cols)=($nc,5);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $tr=$top_ram->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, 
-height =>27,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$tr->rowHeight(0,1); 
$tr->colWidth(20,20,20,20,20,20); 
$tr->colWidth(1=>20,0=>15,2=>22,3=>22,4=>22);
$tr->activate("1,0");
$tr->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$tr->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$arrayVar->{"0,0"} = "Chain";
$arrayVar->{"0,1"} = "Residue Name";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "PHI angle";
$arrayVar->{"0,4"} = "PSI angle";
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
for($i=1;$i<=$nc-1;$i++)
{
$arrayVar->{"$i,0"} = "$ram";
$arrayVar->{"$i,3"} = "$angle[$i-1]";
}
open(FH,$m);
@rn=();@nx=();@ny=();@nz=();@rca=();@cax=();@cay=();@caz=();@rc=();@cx=();@cy=();@cz=();
$nc=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ram)
{
if(substr($_,13,3) eq 'N  ')
{
$nc++;
push(@rn,substr($_,23,3));
push(@nx,substr($_,31,7));
push(@ny,substr($_,39,7));
push(@nz,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rca,substr($_,23,3));
push(@cax,substr($_,31,7));
push(@cay,substr($_,39,7));
push(@caz,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rc,substr($_,23,3));
push(@cx,substr($_,31,7));
push(@cy,substr($_,39,7));
push(@cz,substr($_,47,7));
}
}
}
}
@v1x=();@v1y=();@v1z=();
@v2x=();@v2y=();@v2z=();
@v3x=();@v3y=();@v3z=();
for($i=1;$i<$nc;$i++)
{
push(@v1x,$cax[$i-1]-$nx[$i-1]);
push(@v1y,$cay[$i-1]-$ny[$i-1]);
push(@v1z,$caz[$i-1]-$nz[$i-1]);
push(@v2x,$cx[$i-1]-$cax[$i-1]);
push(@v2y,$cy[$i-1]-$cay[$i-1]);
push(@v2z,$cz[$i-1]-$caz[$i-1]);
push(@v3x,$nx[$i]-$cx[$i-1]);
push(@v3y,$ny[$i]-$cy[$i-1]);
push(@v3z,$nz[$i]-$cz[$i-1]);
}
@pyz=();@pxz=();@pxy=();
@qyz=();@qxz=();@qxy=();
for($i=0;$i<$nc;$i++)
{
push(@pyz,$v1y[$i]*$v2z[$i]-$v1z[$i]*$v2y[$i]);
push(@pxz,$v1z[$i]*$v2x[$i]-$v1x[$i]*$v2z[$i]);
push(@pxy,$v1x[$i]*$v2y[$i]-$v1y[$i]*$v2x[$i]);
push(@qyz,$v2y[$i]*$v3z[$i]-$v2z[$i]*$v3y[$i]);
push(@qxz,$v2z[$i]*$v3x[$i]-$v2x[$i]*$v3z[$i]);
push(@qxy,$v2x[$i]*$v3y[$i]-$v2y[$i]*$v3x[$i]);
}
@r1=();@r2=();@r3=();
for($i=0;$i<$nc;$i++)
{
push(@r1,$pzx[$i]*$qxy[$i]-$pxy[$i]*$qzx[$i]);
push(@r2,$pxy[$i]*$qyz[$i]-$pyz[$i]*$qxy[$i]);
push(@r3,$pyz[$i]*$qzx[$i]-$pzx[$i]*$qyz[$i]);
}
@l=();@lp=();@lq=();@cosval=();@sinval=();@angle=();
for($i=0;$i<$nc-1;$i++)
{
$sum[$i]=$pyz[$i]*$qyz[$i]+$pxz[$i]*$qxz[$i]+$pxy[$i]*$qxy[$i];
$lp[$i]=sqrt($pyz[$i]*$pyz[$i]+$pxz[$i]*$pxz[$i]+$pxy[$i]*$pxy[$i]);
$lq[$i]=sqrt($qyz[$i]*$qyz[$i]+$qxz[$i]*$qxz[$i]+$qxy[$i]*$qxy[$i]);
$l[$i]=$lp[$i]*$lq[$i];
}
for($i=0;$i<$nc-1;$i++)
{
$cosval[$i]+=$sum[$i]/$l[$i];
$sinsqval[$i]=1-($cosval[$i]*$cosval[$i]);
if($sinsqval[$i]<0)
{
$sinsqval[$i]=0;
}
$sinval[$i]=sqrt($sinsqval[$i]);
$angle[$i]=-(atan2($sinval[$i],$cosval[$i])*57.29578);
}
@sum1=();
for($i=0;$i<$nc-1;$i++)
{
$sum1[$i]=$r1[$i]*$v2x[$i]+$r2[$i]*$v2y[$i]+$r3[$i]*$v3z[$i];
#print $sum1[$i],"\n";
if($sum1[$i] > 0)
{
$angle[$i] = -$angle[$i];
}
}

for($i=1;$i<=$nc-1;$i++)
{
$arrayVar->{"$i,0"} = "$ram";
$arrayVar->{"$i,4"} = "$angle[$i]";
}
}
sub psiangle
{
my ($a,$ram)=@_;
$scale1->destroy();
$scale1 = $subframe3_ram->Scale();
$scale1->configure(-label        => 'Psi angles',
-orient       => 'horizontal',
-length       => 600,
-from         => -180,
-to           => 180,
-showvalue    => 'true',
-tickinterval => 25,
-variable     => \$scaleval1,
-command      => sub {$psi=$scaleval1; ramrange($a,$psi,$ram)});
$scale1->pack();
}
sub ramrange
{
my($a,$b,$ram)=@_;
$frame2_ram->destroy();
$frame2_ram=$mw_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$frame2_ram->pack(-anchor=>'nw',-side=>'left',-expand=>0);
$subframe2_ram->destroy();
$subframe2_ram=$frame1_ram->Frame(-relief=>'sunken',-borderwidth=>5);
$subframe2_ram->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$subframe1_ram);
$r=$frame2_ram->Canvas(-width =>686, -height =>686); 
$r->pack;
$r->createRectangle(0, 0,19,19,-fill=>'yellow');
$r->createRectangle(0,19,19,38,-fill=>'yellow');
$r->createRectangle(0,38,19,57,-fill=>'yellow');
$r->createRectangle(0,57,19,76,-fill=>'yellow');
$r->createRectangle(0,76,19,95,-fill=>'yellow');
$r->createRectangle(0,95,19,114,-fill=>'yellow');
$r->createRectangle(0,114,19,133,-fill=>'yellow');
$r->createRectangle(0,133,19,152,-fill=>'yellow');
$r->createRectangle(0,152,19,171,-fill=>'yellow');
$r->createRectangle(0,171,19,190,-fill=>'yellow');
$r->createRectangle(0,190,19,209,-fill=>'yellow');
$r->createRectangle(0,209,19,228,-fill=>"#DAA520");
$r->createRectangle(0,228,19,247,-fill=>"#DAA520");
$r->createRectangle(0,247,19,266,-fill=>"#DAA520");
$r->createRectangle(0,266,19,285,-fill=>"#DAA520");
$r->createRectangle(0,285,19,304,-fill=>"#DAA520");
$r->createRectangle(0,304,19,323,-fill=>"#DAA520");
$r->createRectangle(0,323,19,342,-fill=>"#DAA520");
$r->createRectangle(0,342,19,361,-fill=>"#DAA520");
$r->createRectangle(0,361,19,380,-fill=>"#DAA520");
$r->createRectangle(0,380,19,399,-fill=>"#DAA520");
$r->createRectangle(0,399,19,418,-fill=>"#DAA520");
$r->createRectangle(0,418,19,437,-fill=>"#DAA520");
$r->createRectangle(0,437,19,456,-fill=>"#DAA520");
$r->createRectangle(0,456,19,475,-fill=>'yellow');
$r->createRectangle(0,475,19,494,-fill=>"#DAA520");
$r->createRectangle(0,494,19,513,-fill=>"#DAA520");
$r->createRectangle(0,513,19,532,-fill=>'white');
$r->createRectangle(0,532,19,551,-fill=>'white');
$r->createRectangle(0,551,19,570,-fill=>'white');
$r->createRectangle(0,570,19,589,-fill=>"#DAA520");
$r->createRectangle(0,589,19,608,-fill=>"#DAA520");
$r->createRectangle(0,608,19,627,-fill=>"#DAA520");
$r->createRectangle(0,627,19,646,-fill=>"#DAA520");
$r->createRectangle(0,646,19,665,-fill=>"#DAA520");
$r->createRectangle(0,665,19,684,-fill=>'yellow');
#i=2;
$r->createRectangle(19,0,38,19,-fill=>'red');
$r->createRectangle(19,19,38,38,-fill=>'red');
$r->createRectangle(19,38,38,57,-fill=>'red');
$r->createRectangle(19,57,38,76,-fill=>'yellow');
$r->createRectangle(19,76,38,95,-fill=>'yellow');
$r->createRectangle(19,95,38,114,-fill=>'yellow');
$r->createRectangle(19,114,38,133,-fill=>'yellow');
$r->createRectangle(19,133,38,152,-fill=>'yellow');
$r->createRectangle(19,152,38,171,-fill=>'yellow');
$r->createRectangle(19,171,38,190,-fill=>'yellow');
$r->createRectangle(19,190,38,209,-fill=>'yellow');
$r->createRectangle(19,209,38,228,-fill=>'yellow');
$r->createRectangle(19,228,38,247,-fill=>"#DAA520");
$r->createRectangle(19,247,38,266,-fill=>"#DAA520");
$r->createRectangle(19,266,38,285,-fill=>'yellow');
$r->createRectangle(19,285,38,304,-fill=>'yellow');
$r->createRectangle(19,304,38,323,-fill=>'yellow');
$r->createRectangle(19,323,38,342,-fill=>'yellow');
$r->createRectangle(19,342,38,361,-fill=>'yellow');
$r->createRectangle(19,361,38,380,-fill=>'yellow');
$r->createRectangle(19,380,38,399,-fill=>"#DAA520");
$r->createRectangle(19,399,38,418,-fill=>"#DAA520");
$r->createRectangle(19,418,38,437,-fill=>"#DAA520");
$r->createRectangle(19,437,38,456,-fill=>'yellow');
$r->createRectangle(19,456,38,475,-fill=>'yellow');
$r->createRectangle(19,475,38,494,-fill=>"#DAA520");
$r->createRectangle(19,494,38,513,-fill=>"#DAA520");
$r->createRectangle(19,513,38,532,-fill=>"#DAA520");
$r->createRectangle(19,532,38,551,-fill=>'white');
$r->createRectangle(19,551,38,570,-fill=>'white');
$r->createRectangle(19,570,38,589,-fill=>"#DAA520");
$r->createRectangle(19,589,38,608,-fill=>"#DAA520");
$r->createRectangle(19,608,38,627,-fill=>'yellow');
$r->createRectangle(19,627,38,646,-fill=>'yellow');
$r->createRectangle(19,646,38,665,-fill=>'yellow');
$r->createRectangle(19,665,38,684,-fill=>'yellow');
#i=3;
$r->createRectangle(38,0,57,19,-fill=>'red');
$r->createRectangle(38,19,57,38,-fill=>'red');
$r->createRectangle(38,38,57,57,-fill=>'red');
$r->createRectangle(38,57,57,76,-fill=>'red');
$r->createRectangle(38,76,57,95,-fill=>'red');
$r->createRectangle(38,95,57,114,-fill=>'red');
$r->createRectangle(38,114,57,133,-fill=>'yellow');
$r->createRectangle(38,133,57,152,-fill=>'yellow');
$r->createRectangle(38,152,57,171,-fill=>'yellow');
$r->createRectangle(38,171,57,190,-fill=>'yellow');
$r->createRectangle(38,190,57,209,-fill=>'yellow');
$r->createRectangle(38,209,57,228,-fill=>'yellow');
$r->createRectangle(38,228,57,247,-fill=>'yellow');
$r->createRectangle(38,247,57,266,-fill=>'yellow');
$r->createRectangle(38,266,57,285,-fill=>'yellow');
$r->createRectangle(38,285,57,304,-fill=>'yellow');
$r->createRectangle(38,304,57,323,-fill=>'yellow');
$r->createRectangle(38,323,57,342,-fill=>'yellow');
$r->createRectangle(38,342,57,361,-fill=>'yellow');
$r->createRectangle(38,361,57,380,-fill=>'yellow');
$r->createRectangle(38,380,57,399,-fill=>'yellow');
$r->createRectangle(38,399,57,418,-fill=>'yellow');
$r->createRectangle(38,418,57,437,-fill=>"#DAA520");
$r->createRectangle(38,437,57,456,-fill=>'yellow');
$r->createRectangle(38,456,57,475,-fill=>"#DAA520");
$r->createRectangle(38,475,57,494,-fill=>"#DAA520");
$r->createRectangle(38,494,57,513,-fill=>"#DAA520");
$r->createRectangle(38,513,57,532,-fill=>"#DAA520");
$r->createRectangle(38,532,57,551,-fill=>'white');
$r->createRectangle(38,551,57,570,-fill=>'white');
$r->createRectangle(38,570,57,589,-fill=>"#DAA520");
$r->createRectangle(38,589,57,608,-fill=>"#DAA520");
$r->createRectangle(38,608,57,627,-fill=>'yellow');
$r->createRectangle(38,627,57,646,-fill=>'yellow');
$r->createRectangle(38,646,57,665,-fill=>'yellow');
$r->createRectangle(38,665,57,684,-fill=>'yellow');
#i=4;
$r->createRectangle(57,0,76,19,-fill=>'red');
$r->createRectangle(57,19,76,38,-fill=>'red');
$r->createRectangle(57,38,76,57,-fill=>'red');
$r->createRectangle(57,57,76,76,-fill=>'red');
$r->createRectangle(57,76,76,95,-fill=>'red');
$r->createRectangle(57,95,76,114,-fill=>'red');
$r->createRectangle(57,114,76,133,-fill=>'red');
$r->createRectangle(57,133,76,152,-fill=>'yellow');
$r->createRectangle(57,152,76,171,-fill=>'yellow');
$r->createRectangle(57,171,76,190,-fill=>'yellow');
$r->createRectangle(57,190,76,209,-fill=>'yellow');
$r->createRectangle(57,209,76,228,-fill=>'yellow');
$r->createRectangle(57,228,76,247,-fill=>'yellow');
$r->createRectangle(57,247,76,266,-fill=>'yellow');
$r->createRectangle(57,266,76,285,-fill=>'yellow');
$r->createRectangle(57,285,76,304,-fill=>'yellow');
$r->createRectangle(57,304,76,323,-fill=>'yellow');
$r->createRectangle(57,323,76,342,-fill=>'yellow');
$r->createRectangle(57,342,76,361,-fill=>'yellow');
$r->createRectangle(57,361,76,380,-fill=>'yellow');
$r->createRectangle(57,380,76,399,-fill=>'yellow');
$r->createRectangle(57,399,76,418,-fill=>'yellow');
$r->createRectangle(57,418,76,437,-fill=>'yellow');
$r->createRectangle(57,437,76,456,-fill=>'yellow');
$r->createRectangle(57,456,76,475,-fill=>'yellow');
$r->createRectangle(57,475,76,494,-fill=>'yellow');
$r->createRectangle(57,494,76,513,-fill=>"#DAA520");
$r->createRectangle(57,513,76,532,-fill=>"#DAA520");
$r->createRectangle(57,532,76,551,-fill=>"#DAA520");
$r->createRectangle(57,551,76,570,-fill=>"#DAA520");
$r->createRectangle(57,570,76,589,-fill=>"#DAA520");
$r->createRectangle(57,589,76,608,-fill=>"#DAA520");
$r->createRectangle(57,608,76,627,-fill=>'yellow');
$r->createRectangle(57,627,76,646,-fill=>'yellow');
$r->createRectangle(57,646,76,665,-fill=>'yellow');
$r->createRectangle(57,665,76,684,-fill=>'yellow');
#i=5;
$r->createRectangle(76,0,95,19,-fill=>'red');
$r->createRectangle(76,19,95,38,-fill=>'red');
$r->createRectangle(76,38,95,57,-fill=>'red');
$r->createRectangle(76,57,95,76,-fill=>'red');
$r->createRectangle(76,76,95,95,-fill=>'red');
$r->createRectangle(76,95,95,114,-fill=>'red');
$r->createRectangle(76,114,95,133,-fill=>'red');
$r->createRectangle(76,133,95,152,-fill=>'red');
$r->createRectangle(76,152,95,171,-fill=>'yellow');
$r->createRectangle(76,171,95,190,-fill=>'yellow');
$r->createRectangle(76,190,95,209,-fill=>'yellow');
$r->createRectangle(76,209,95,228,-fill=>'yellow');
$r->createRectangle(76,228,95,247,-fill=>'yellow');
$r->createRectangle(76,247,95,266,-fill=>'yellow');
$r->createRectangle(76,266,95,285,-fill=>'yellow');
$r->createRectangle(76,285,95,304,-fill=>'yellow');
$r->createRectangle(76,304,95,323,-fill=>'yellow');
$r->createRectangle(76,323,95,342,-fill=>'yellow');
$r->createRectangle(76,342,95,361,-fill=>'yellow');
$r->createRectangle(76,361,95,380,-fill=>'yellow');
$r->createRectangle(76,380,95,399,-fill=>'yellow');
$r->createRectangle(76,399,95,418,-fill=>'yellow');
$r->createRectangle(76,418,95,437,-fill=>'yellow');
$r->createRectangle(76,437,95,456,-fill=>'yellow');
$r->createRectangle(76,456,95,475,-fill=>'yellow');
$r->createRectangle(76,475,95,494,-fill=>'yellow');
$r->createRectangle(76,494,95,513,-fill=>"#DAA520");
$r->createRectangle(76,513,95,532,-fill=>"#DAA520");
$r->createRectangle(76,532,95,551,-fill=>"#DAA520");
$r->createRectangle(76,551,95,570,-fill=>"#DAA520");
$r->createRectangle(76,570,95,589,-fill=>"#DAA520");
$r->createRectangle(76,589,95,608,-fill=>"#DAA520");
$r->createRectangle(76,608,95,627,-fill=>"#DAA520");
$r->createRectangle(76,627,95,646,-fill=>'yellow');
$r->createRectangle(76,646,95,665,-fill=>'yellow');
$r->createRectangle(76,665,95,684,-fill=>'yellow');
#i=6;
$r->createRectangle(95,0,114,19,-fill=>'red');
$r->createRectangle(95,19,114,38,-fill=>'red');
$r->createRectangle(95,38,114,57,-fill=>'red');
$r->createRectangle(95,57,114,76,-fill=>'red');
$r->createRectangle(95,76,114,95,-fill=>'red');
$r->createRectangle(95,95,114,114,-fill=>'red');
$r->createRectangle(95,114,114,133,-fill=>'red');
$r->createRectangle(95,133,114,152,-fill=>'red');
$r->createRectangle(95,152,114,171,-fill=>'red');
$r->createRectangle(95,171,114,190,-fill=>'yellow');
$r->createRectangle(95,190,114,209,-fill=>'yellow');
$r->createRectangle(95,209,114,228,-fill=>'yellow');
$r->createRectangle(95,228,114,247,-fill=>'yellow');
$r->createRectangle(95,247,114,266,-fill=>'yellow');
$r->createRectangle(95,266,114,285,-fill=>'yellow');
$r->createRectangle(95,285,114,304,-fill=>'yellow');
$r->createRectangle(95,304,114,323,-fill=>'yellow');
$r->createRectangle(95,323,114,342,-fill=>'yellow');
$r->createRectangle(95,342,114,361,-fill=>'red');
$r->createRectangle(95,361,114,380,-fill=>'yellow');
$r->createRectangle(95,380,114,399,-fill=>'yellow');
$r->createRectangle(95,399,114,418,-fill=>'yellow');
$r->createRectangle(95,418,114,437,-fill=>'yellow');
$r->createRectangle(95,437,114,456,-fill=>'yellow');
$r->createRectangle(95,456,114,475,-fill=>'yellow');
$r->createRectangle(95,475,114,494,-fill=>'yellow');
$r->createRectangle(95,494,114,513,-fill=>'yellow');
$r->createRectangle(95,513,114,532,-fill=>'yellow');
$r->createRectangle(95,532,114,551,-fill=>"#DAA520");
$r->createRectangle(95,551,114,570,-fill=>"#DAA520");
$r->createRectangle(95,570,114,589,-fill=>'yellow');
$r->createRectangle(95,589,114,608,-fill=>"#DAA520");
$r->createRectangle(95,608,114,627,-fill=>'yellow');
$r->createRectangle(95,627,114,646,-fill=>'yellow');
$r->createRectangle(95,646,114,665,-fill=>'yellow');
$r->createRectangle(95,665,114,684,-fill=>'yellow');
#i=7;
$r->createRectangle(114,0,133,19,-fill=>'red');
$r->createRectangle(114,19,133,38,-fill=>'red');
$r->createRectangle(114,38,133,57,-fill=>'red');
$r->createRectangle(114,57,133,76,-fill=>'red');
$r->createRectangle(114,76,133,95,-fill=>'red');
$r->createRectangle(114,95,133,114,-fill=>'red');
$r->createRectangle(114,114,133,133,-fill=>'red');
$r->createRectangle(114,133,133,152,-fill=>'red');
$r->createRectangle(114,152,133,171,-fill=>'yellow');
$r->createRectangle(114,171,133,190,-fill=>'yellow');
$r->createRectangle(114,190,133,209,-fill=>'yellow');
$r->createRectangle(114,209,133,228,-fill=>'yellow');
$r->createRectangle(114,228,133,247,-fill=>'yellow');
$r->createRectangle(114,247,133,266,-fill=>'yellow');
$r->createRectangle(114,266,133,285,-fill=>'yellow');
$r->createRectangle(114,285,133,304,-fill=>'yellow');
$r->createRectangle(114,304,133,323,-fill=>'red');
$r->createRectangle(114,323,133,342,-fill=>'red');
$r->createRectangle(114,342,133,361,-fill=>'red');
$r->createRectangle(114,361,133,380,-fill=>'yellow');
$r->createRectangle(114,380,133,399,-fill=>'yellow');
$r->createRectangle(114,399,133,418,-fill=>'yellow');
$r->createRectangle(114,418,133,437,-fill=>'yellow');
$r->createRectangle(114,437,133,456,-fill=>'yellow');
$r->createRectangle(114,456,133,475,-fill=>'yellow');
$r->createRectangle(114,475,133,494,-fill=>'yellow');
$r->createRectangle(114,494,133,513,-fill=>"#DAA520");
$r->createRectangle(114,513,133,532,-fill=>"#DAA520");
$r->createRectangle(114,532,133,551,-fill=>"#DAA520");
$r->createRectangle(114,551,133,570,-fill=>'yellow');
$r->createRectangle(114,570,133,589,-fill=>'yellow');
$r->createRectangle(114,589,133,608,-fill=>'yellow');
$r->createRectangle(114,608,133,627,-fill=>'yellow');
$r->createRectangle(114,627,133,646,-fill=>'yellow');
$r->createRectangle(114,646,133,665,-fill=>'yellow');
$r->createRectangle(114,665,133,684,-fill=>'yellow');
#i=8;
$r->createRectangle(133,0,152,19,-fill=>'red');
$r->createRectangle(133,19,152,38,-fill=>'red');
$r->createRectangle(133,38,152,57,-fill=>'red');
$r->createRectangle(133,57,152,76,-fill=>'red');
$r->createRectangle(133,76,152,95,-fill=>'red');
$r->createRectangle(133,95,152,114,-fill=>'red');
$r->createRectangle(133,114,152,133,-fill=>'red');
$r->createRectangle(133,133,152,152,-fill=>'red');
$r->createRectangle(133,152,152,171,-fill=>'yellow');
$r->createRectangle(133,171,152,190,-fill=>'yellow');
$r->createRectangle(133,190,152,209,-fill=>'yellow');
$r->createRectangle(133,209,152,228,-fill=>'yellow');
$r->createRectangle(133,228,152,247,-fill=>'yellow');
$r->createRectangle(133,247,152,266,-fill=>'yellow');
$r->createRectangle(133,266,152,285,-fill=>'yellow');
$r->createRectangle(133,285,152,304,-fill=>'red');
$r->createRectangle(133,304,152,323,-fill=>'red');
$r->createRectangle(133,323,152,342,-fill=>'red');
$r->createRectangle(133,342,152,361,-fill=>'red');
$r->createRectangle(133,361,152,380,-fill=>'red');
$r->createRectangle(133,380,152,399,-fill=>'red');
$r->createRectangle(133,399,152,418,-fill=>'red');
$r->createRectangle(133,418,152,437,-fill=>'yellow');
$r->createRectangle(133,437,152,456,-fill=>'yellow');
$r->createRectangle(133,456,152,475,-fill=>'yellow');
$r->createRectangle(133,475,152,494,-fill=>'yellow');
$r->createRectangle(133,494,152,513,-fill=>'yellow');
$r->createRectangle(133,513,152,532,-fill=>'yellow');
$r->createRectangle(133,532,152,551,-fill=>"#DAA520");
$r->createRectangle(133,551,152,570,-fill=>'yellow');
$r->createRectangle(133,570,152,589,-fill=>"#DAA520");
$r->createRectangle(133,589,152,608,-fill=>'yellow');
$r->createRectangle(133,608,152,627,-fill=>'yellow');
$r->createRectangle(133,627,152,646,-fill=>'yellow');
$r->createRectangle(133,646,152,665,-fill=>'yellow');
$r->createRectangle(133,665,152,684,-fill=>'yellow');
#i=9;
$r->createRectangle(152,0,171,19,-fill=>'red');
$r->createRectangle(152,19,171,38,-fill=>'red');
$r->createRectangle(152,38,171,57,-fill=>'red');
$r->createRectangle(152,57,171,76,-fill=>'red');
$r->createRectangle(152,76,171,95,-fill=>'red');
$r->createRectangle(152,95,171,114,-fill=>'red');
$r->createRectangle(152,114,171,133,-fill=>'red');
$r->createRectangle(152,133,171,152,-fill=>'red');
$r->createRectangle(152,152,171,171,-fill=>'red');
$r->createRectangle(152,171,171,190,-fill=>'yellow');
$r->createRectangle(152,190,171,209,-fill=>'yellow');
$r->createRectangle(152,209,171,228,-fill=>'yellow');
$r->createRectangle(152,228,171,247,-fill=>'yellow');
$r->createRectangle(152,247,171,266,-fill=>'yellow');
$r->createRectangle(152,266,171,285,-fill=>'yellow');
$r->createRectangle(152,285,171,304,-fill=>'yellow');
$r->createRectangle(152,304,171,323,-fill=>'red');
$r->createRectangle(152,323,171,342,-fill=>'red');
$r->createRectangle(152,342,171,361,-fill=>'red');
$r->createRectangle(152,361,171,380,-fill=>'red');
$r->createRectangle(152,380,171,399,-fill=>'red');
$r->createRectangle(152,399,171,418,-fill=>'red');
$r->createRectangle(152,418,171,437,-fill=>'red');
$r->createRectangle(152,437,171,456,-fill=>'yellow');
$r->createRectangle(152,456,171,475,-fill=>'yellow');
$r->createRectangle(152,475,171,494,-fill=>'yellow');
$r->createRectangle(152,494,171,513,-fill=>'yellow');
$r->createRectangle(152,513,171,532,-fill=>'yellow');
$r->createRectangle(152,532,171,551,-fill=>"#DAA520");
$r->createRectangle(152,551,171,570,-fill=>'yellow');
$r->createRectangle(152,570,171,589,-fill=>"#DAA520");
$r->createRectangle(152,589,171,608,-fill=>'yellow');
$r->createRectangle(152,608,171,627,-fill=>'yellow');
$r->createRectangle(152,627,171,646,-fill=>'yellow');
$r->createRectangle(152,646,171,665,-fill=>'yellow');
$r->createRectangle(152,665,171,684,-fill=>'yellow');
#i=10;
$r->createRectangle(171,0,190,19,-fill=>'red');
$r->createRectangle(171,19,190,38,-fill=>'red');
$r->createRectangle(171,38,190,57,-fill=>'red');
$r->createRectangle(171,57,190,76,-fill=>'red');
$r->createRectangle(171,76,190,95,-fill=>'red');
$r->createRectangle(171,95,190,114,-fill=>'red');
$r->createRectangle(171,114,190,133,-fill=>'red');
$r->createRectangle(171,133,190,152,-fill=>'red');
$r->createRectangle(171,152,190,171,-fill=>'yellow');
$r->createRectangle(171,171,190,190,-fill=>'yellow');
$r->createRectangle(171,190,190,209,-fill=>'yellow');
$r->createRectangle(171,209,190,228,-fill=>'yellow');
$r->createRectangle(171,228,190,247,-fill=>'yellow');
$r->createRectangle(171,247,190,266,-fill=>'yellow');
$r->createRectangle(171,266,190,285,-fill=>'yellow');
$r->createRectangle(171,285,190,304,-fill=>'yellow');
$r->createRectangle(171,304,190,323,-fill=>'red');
$r->createRectangle(171,323,190,342,-fill=>'red');
$r->createRectangle(171,342,190,361,-fill=>'red');
$r->createRectangle(171,361,190,380,-fill=>'red');
$r->createRectangle(171,380,190,399,-fill=>'red');
$r->createRectangle(171,399,190,418,-fill=>'red');
$r->createRectangle(171,418,190,437,-fill=>'red');
$r->createRectangle(171,437,190,456,-fill=>'red');
$r->createRectangle(171,456,190,475,-fill=>'yellow');
$r->createRectangle(171,475,190,494,-fill=>'yellow');
$r->createRectangle(171,494,190,513,-fill=>'yellow');
$r->createRectangle(171,513,190,532,-fill=>'yellow');
$r->createRectangle(171,532,190,551,-fill=>"#DAA520");
$r->createRectangle(171,551,190,570,-fill=>"#DAA520");
$r->createRectangle(171,570,190,589,-fill=>"#DAA520");
$r->createRectangle(171,589,190,608,-fill=>'yellow');
$r->createRectangle(171,608,190,627,-fill=>'yellow');
$r->createRectangle(171,627,190,646,-fill=>'yellow');
$r->createRectangle(171,646,190,665,-fill=>'yellow');
$r->createRectangle(171,665,190,684,-fill=>'yellow');
#i=11;
$r->createRectangle(190,0,209,19,-fill=>'red');
$r->createRectangle(190,19,209,38,-fill=>'red');
$r->createRectangle(190,38,209,57,-fill=>'red');
$r->createRectangle(190,57,209,76,-fill=>'red');
$r->createRectangle(190,76,209,95,-fill=>'red');
$r->createRectangle(190,95,209,114,-fill=>'red');
$r->createRectangle(190,114,209,133,-fill=>'red');
$r->createRectangle(190,133,209,152,-fill=>'red');
$r->createRectangle(190,152,209,171,-fill=>'yellow');
$r->createRectangle(190,171,209,190,-fill=>'yellow');
$r->createRectangle(190,190,209,209,-fill=>'yellow');
$r->createRectangle(190,209,209,228,-fill=>'yellow');
$r->createRectangle(190,228,209,247,-fill=>'yellow');
$r->createRectangle(190,247,209,266,-fill=>'yellow');
$r->createRectangle(190,266,209,285,-fill=>'yellow');
$r->createRectangle(190,285,209,304,-fill=>'yellow');
$r->createRectangle(190,304,209,323,-fill=>'yellow');
$r->createRectangle(190,323,209,342,-fill=>'red');
$r->createRectangle(190,342,209,361,-fill=>'red');
$r->createRectangle(190,361,209,380,-fill=>'red');
$r->createRectangle(190,380,209,399,-fill=>'red');
$r->createRectangle(190,399,209,418,-fill=>'red');
$r->createRectangle(190,418,209,437,-fill=>'red');
$r->createRectangle(190,437,209,456,-fill=>'red');
$r->createRectangle(190,456,209,475,-fill=>'yellow');
$r->createRectangle(190,475,209,494,-fill=>'yellow');
$r->createRectangle(190,494,209,513,-fill=>'yellow');
$r->createRectangle(190,513,209,532,-fill=>'yellow');
$r->createRectangle(190,532,209,551,-fill=>"#DAA520");
$r->createRectangle(190,551,209,570,-fill=>"#DAA520");
$r->createRectangle(190,570,209,589,-fill=>"#DAA520");
$r->createRectangle(190,589,209,608,-fill=>"#DAA520");
$r->createRectangle(190,608,209,627,-fill=>"#DAA520");
$r->createRectangle(190,627,209,646,-fill=>'yellow');
$r->createRectangle(190,646,209,665,-fill=>'yellow');
$r->createRectangle(190,665,209,684,-fill=>'yellow');
#i=12;
$r->createRectangle(209,0,228,19,-fill=>'yellow');
$r->createRectangle(209,19,228,38,-fill=>'red');
$r->createRectangle(209,38,228,57,-fill=>'red');
$r->createRectangle(209,57,228,76,-fill=>'red');
$r->createRectangle(209,76,228,95,-fill=>'red');
$r->createRectangle(209,95,228,114,-fill=>'red');
$r->createRectangle(209,114,228,133,-fill=>'red');
$r->createRectangle(209,133,228,152,-fill=>'yellow');
$r->createRectangle(209,152,228,171,-fill=>'yellow');
$r->createRectangle(209,171,228,190,-fill=>'yellow');
$r->createRectangle(209,190,228,209,-fill=>'yellow');
$r->createRectangle(209,209,228,228,-fill=>'yellow');
$r->createRectangle(209,228,228,247,-fill=>'yellow');
$r->createRectangle(209,247,228,266,-fill=>'yellow');
$r->createRectangle(209,266,228,285,-fill=>'yellow');
$r->createRectangle(209,285,228,304,-fill=>'yellow');
$r->createRectangle(209,304,228,323,-fill=>'yellow');
$r->createRectangle(209,323,228,342,-fill=>'yellow');
$r->createRectangle(209,342,228,361,-fill=>'red');
$r->createRectangle(209,361,228,380,-fill=>'red');
$r->createRectangle(209,380,228,399,-fill=>'red');
$r->createRectangle(209,399,228,418,-fill=>'red');
$r->createRectangle(209,418,228,437,-fill=>'red');
$r->createRectangle(209,437,228,456,-fill=>'red');
$r->createRectangle(209,456,228,475,-fill=>'red');
$r->createRectangle(209,475,228,494,-fill=>'yellow');
$r->createRectangle(209,494,228,513,-fill=>'yellow');
$r->createRectangle(209,513,228,532,-fill=>'yellow');
$r->createRectangle(209,532,228,551,-fill=>'yellow');
$r->createRectangle(209,551,228,570,-fill=>"#DAA520");
$r->createRectangle(209,570,228,589,-fill=>"#DAA520");
$r->createRectangle(209,589,228,608,-fill=>"#DAA520");
$r->createRectangle(209,608,228,627,-fill=>"#DAA520");
$r->createRectangle(209,627,228,646,-fill=>"#DAA520");
$r->createRectangle(209,646,228,665,-fill=>'yellow');
$r->createRectangle(209,665,228,684,-fill=>'yellow');
#i=13;
$r->createRectangle(228,0,247,19,-fill=>'yellow');
$r->createRectangle(228,19,247,38,-fill=>'yellow');
$r->createRectangle(228,38,247,57,-fill=>'yellow');
$r->createRectangle(228,57,247,76,-fill=>'red');
$r->createRectangle(228,76,247,95,-fill=>'red');
$r->createRectangle(228,95,247,114,-fill=>'red');
$r->createRectangle(228,114,247,133,-fill=>'yellow');
$r->createRectangle(228,133,247,152,-fill=>'yellow');
$r->createRectangle(228,152,247,171,-fill=>'yellow');
$r->createRectangle(228,171,247,190,-fill=>'yellow');
$r->createRectangle(228,190,247,209,-fill=>"#DAA520");
$r->createRectangle(228,209,247,228,-fill=>'yellow');
$r->createRectangle(228,228,247,247,-fill=>'yellow');
$r->createRectangle(228,247,247,266,-fill=>"#DAA520");
$r->createRectangle(228,266,247,285,-fill=>"#DAA520");
$r->createRectangle(228,285,247,304,-fill=>'yellow');
$r->createRectangle(228,304,247,323,-fill=>'yellow');
$r->createRectangle(228,323,247,342,-fill=>'yellow');
$r->createRectangle(228,342,247,361,-fill=>'yellow');
$r->createRectangle(228,361,247,380,-fill=>'red');
$r->createRectangle(228,380,247,399,-fill=>'red');
$r->createRectangle(228,399,247,418,-fill=>'red');
$r->createRectangle(228,418,247,437,-fill=>'red');
$r->createRectangle(228,437,247,456,-fill=>'red');
$r->createRectangle(228,456,247,475,-fill=>'red');
$r->createRectangle(228,475,247,494,-fill=>'yellow');
$r->createRectangle(228,494,247,513,-fill=>'yellow');
$r->createRectangle(228,513,247,532,-fill=>'yellow');
$r->createRectangle(228,532,247,551,-fill=>"#DAA520");
$r->createRectangle(228,551,247,570,-fill=>"#DAA520");
$r->createRectangle(228,570,247,589,-fill=>"#DAA520");
$r->createRectangle(228,589,247,608,-fill=>"#DAA520");
$r->createRectangle(228,608,247,627,-fill=>"#DAA520");
$r->createRectangle(228,627,247,646,,-fill=>"#DAA520");
$r->createRectangle(228,646,247,665,-fill=>'yellow');
$r->createRectangle(228,665,247,684,-fill=>'yellow');
#i=14;
$r->createRectangle(247,0,266,19,-fill=>'yellow');
$r->createRectangle(247,19,266,38,-fill=>'yellow');
$r->createRectangle(247,38,266,57,-fill=>'yellow');
$r->createRectangle(247,57,266,76,-fill=>'yellow');
$r->createRectangle(247,76,266,95,-fill=>'red');
$r->createRectangle(247,95,266,114,-fill=>'yellow');
$r->createRectangle(247,114,266,133,-fill=>'yellow');
$r->createRectangle(247,133,266,152,-fill=>'yellow');  
$r->createRectangle(247,152,266,171,-fill=>'yellow');  
$r->createRectangle(247,171,266,190,-fill=>'yellow');  
$r->createRectangle(247,190,266,209,-fill=>"#DAA520");  
$r->createRectangle(247,209,266,228,-fill=>"#DAA520");  
$r->createRectangle(247,228,266,247,-fill=>"#DAA520");  
$r->createRectangle(247,247,266,266,-fill=>"#DAA520");  
$r->createRectangle(247,266,266,285,-fill=>"#DAA520");  
$r->createRectangle(247,285,266,304,-fill=>"#DAA520");  
$r->createRectangle(247,304,266,323,-fill=>"#DAA520");  
$r->createRectangle(247,323,266,342,-fill=>'yellow');  
$r->createRectangle(247,342,266,361,-fill=>'yellow');
$r->createRectangle(247,361,266,380,-fill=>'yellow');
$r->createRectangle(247,380,266,399,-fill=>'red');
$r->createRectangle(247,399,266,418,-fill=>'red');
$r->createRectangle(247,418,266,437,-fill=>'red');
$r->createRectangle(247,437,266,456,-fill=>'red');
$r->createRectangle(247,456,266,475,-fill=>'red');
$r->createRectangle(247,475,266,494,-fill=>'yellow');
$r->createRectangle(247,494,266,513,-fill=>'yellow');
$r->createRectangle(247,513,266,532,-fill=>'yellow');
$r->createRectangle(247,532,266,551,-fill=>"#DAA520");
$r->createRectangle(247,551,266,570,-fill=>"#DAA520");
$r->createRectangle(247,570,266,589,-fill=>"#DAA520");
$r->createRectangle(247,589,266,608,-fill=>"#DAA520");
$r->createRectangle(247,608,266,627,-fill=>"#DAA520");
$r->createRectangle(247,627,266,646,-fill=>"#DAA520");
$r->createRectangle(247,646,266,665,-fill=>"#DAA520");
$r->createRectangle(247,665,266,684,-fill=>"#DAA520");
#i=15;
$r->createRectangle(266,0,285,19,-fill=>"#DAA520");
$r->createRectangle(266,19,285,38,-fill=>'yellow');
$r->createRectangle(266,38,285,57,-fill=>'yellow');
$r->createRectangle(266,57,285,76,-fill=>'yellow');
$r->createRectangle(266,76,285,95,-fill=>'yellow');
$r->createRectangle(266,95,285,114,-fill=>'yellow');
$r->createRectangle(266,114,285,133,-fill=>'yellow');
$r->createRectangle(266,133,285,152,-fill=>'yellow');
$r->createRectangle(266,152,285,171,-fill=>'yellow');
$r->createRectangle(266,171,285,190,-fill=>"#DAA520");
$r->createRectangle(266,190,285,209,-fill=>"#DAA520");
$r->createRectangle(266,209,285,228,-fill=>"#DAA520");
$r->createRectangle(266,228,285,247,-fill=>"#DAA520");
$r->createRectangle(266,247,285,266,-fill=>"#DAA520");
$r->createRectangle(266,266,285,285,-fill=>"#DAA520");
$r->createRectangle(266,285,285,304,-fill=>"#DAA520");
$r->createRectangle(266,304,285,323,-fill=>"#DAA520");
$r->createRectangle(266,323,285,342,-fill=>"#DAA520");
$r->createRectangle(266,342,285,361,-fill=>'yellow');
$r->createRectangle(266,361,285,380,-fill=>'yellow');
$r->createRectangle(266,380,285,399,-fill=>'yellow');
$r->createRectangle(266,399,285,418,-fill=>'yellow');
$r->createRectangle(266,418,285,437,-fill=>'red');
$r->createRectangle(266,437,285,456,-fill=>'red');
$r->createRectangle(266,456,285,475,-fill=>'red');
$r->createRectangle(266,475,285,494,-fill=>'yellow');
$r->createRectangle(266,494,285,513,-fill=>'yellow');
$r->createRectangle(266,513,285,532,-fill=>'yellow');
$r->createRectangle(266,532,285,551,-fill=>"#DAA520");
$r->createRectangle(266,551,285,570,-fill=>"#DAA520");
$r->createRectangle(266,570,285,589,-fill=>'white');
$r->createRectangle(266,589,285,608,-fill=>'white');
$r->createRectangle(266,608,285,627,-fill=>"#DAA520");
$r->createRectangle(266,627,285,646,-fill=>"#DAA520");
$r->createRectangle(266,646,285,665,-fill=>"#DAA520");
$r->createRectangle(266,665,285,684,-fill=>"#DAA520");
#i=16;
$r->createRectangle(285,0,304,19,-fill=>"#DAA520");
$r->createRectangle(285,19,304,38,-fill=>"#DAA520");
$r->createRectangle(285,38,304,57,-fill=>"#DAA520");
$r->createRectangle(285,57,304,76,-fill=>'yellow');
$r->createRectangle(285,76,304,95,-fill=>'yellow');
$r->createRectangle(285,95,304,114,-fill=>'yellow');
$r->createRectangle(285,114,304,133,-fill=>'yellow');
$r->createRectangle(285,133,304,152,-fill=>'yellow');
$r->createRectangle(285,152,304,171,-fill=>'yellow');
$r->createRectangle(285,171,304,190,-fill=>"#DAA520");
$r->createRectangle(285,190,304,209,-fill=>"#DAA520");
$r->createRectangle(285,209,304,228,-fill=>'white');
$r->createRectangle(285,228,304,247,-fill=>'white');
$r->createRectangle(285,247,304,266,-fill=>'white');
$r->createRectangle(285,266,304,285,-fill=>'white');
$r->createRectangle(285,285,304,304,-fill=>"#DAA520");
$r->createRectangle(285,304,304,323,-fill=>"#DAA520");
$r->createRectangle(285,323,304,342,-fill=>"#DAA520");
$r->createRectangle(285,342,304,361,-fill=>"#DAA520");
$r->createRectangle(285,361,304,380,-fill=>"#DAA520");
$r->createRectangle(285,380,304,399,-fill=>'yellow');
$r->createRectangle(285,399,304,418,-fill=>'yellow');
$r->createRectangle(285,418,304,437,-fill=>'yellow');
$r->createRectangle(285,437,304,456,-fill=>'yellow');
$r->createRectangle(285,456,304,475,-fill=>'yellow');
$r->createRectangle(285,475,304,494,-fill=>'yellow');
$r->createRectangle(285,494,304,513,-fill=>'yellow');
$r->createRectangle(285,513,304,532,-fill=>"#DAA520");
$r->createRectangle(285,532,304,551,-fill=>"#DAA520");
$r->createRectangle(285,551,304,570,-fill=>"#DAA520");
$r->createRectangle(285,570,304,589,-fill=>'white');
$r->createRectangle(285,589,304,608,-fill=>'white');
$r->createRectangle(285,608,304,627,-fill=>'white');
$r->createRectangle(285,627,304,646,-fill=>'white');
$r->createRectangle(285,646,304,665,-fill=>'white');
$r->createRectangle(285,665,304,684,-fill=>'white');
#i=17;
$r->createRectangle(304,0,323,19,-fill=>'white');
$r->createRectangle(304,19,323,38,-fill=>"#DAA520");
$r->createRectangle(304,38,323,57,-fill=>"#DAA520");
$r->createRectangle(304,57,323,76,-fill=>'yellow');
$r->createRectangle(304,76,323,95,-fill=>"#DAA520");
$r->createRectangle(304,95,323,114,-fill=>"#DAA520");
$r->createRectangle(304,114,323,133,-fill=>"#DAA520");
$r->createRectangle(304,133,323,152,-fill=>'yellow');
$r->createRectangle(304,152,323,171,-fill=>'yellow');
$r->createRectangle(304,171,323,190,-fill=>"#DAA520");
$r->createRectangle(304,190,323,209,-fill=>"#DAA520");
$r->createRectangle(304,209,323,228,-fill=>'white');
$r->createRectangle(304,228,323,247,-fill=>'white');
$r->createRectangle(304,247,323,266,-fill=>'white');
$r->createRectangle(304,266,323,285,-fill=>'white');
$r->createRectangle(304,285,323,304,-fill=>'white');
$r->createRectangle(304,304,323,323,-fill=>"#DAA520");
$r->createRectangle(304,323,323,342,-fill=>"#DAA520");
$r->createRectangle(304,342,323,361,-fill=>"#DAA520");
$r->createRectangle(304,361,323,380,-fill=>"#DAA520");
$r->createRectangle(304,380,323,399,-fill=>"#DAA520");
$r->createRectangle(304,399,323,418,-fill=>'yellow');
$r->createRectangle(304,418,323,437,-fill=>'yellow');
$r->createRectangle(304,437,323,456,-fill=>'yellow');
$r->createRectangle(304,456,323,475,-fill=>'yellow');
$r->createRectangle(304,475,323,494,-fill=>'yellow');
$r->createRectangle(304,494,323,513,-fill=>'yellow');
$r->createRectangle(304,513,323,532,-fill=>"#DAA520");
$r->createRectangle(304,532,323,551,-fill=>"#DAA520");
$r->createRectangle(304,551,323,570,-fill=>"#DAA520");
$r->createRectangle(304,570,323,589,-fill=>'white');
$r->createRectangle(304,589,323,608,-fill=>'white');
$r->createRectangle(304,608,323,627,-fill=>'white');
$r->createRectangle(304,627,323,646,-fill=>'white');
$r->createRectangle(304,646,323,665,-fill=>'white');
$r->createRectangle(304,665,323,684,-fill=>'white');
#i=18;
$r->createRectangle(323,0,342,19,-fill=>'white');
$r->createRectangle(323,19,342,38,-fill=>'white');
$r->createRectangle(323,38,342,57,-fill=>"#DAA520");
$r->createRectangle(323,57,342,76,-fill=>"#DAA520");
$r->createRectangle(323,76,342,95,-fill=>"#DAA520");
$r->createRectangle(323,95,342,114,-fill=>"#DAA520");
$r->createRectangle(323,114,342,133,-fill=>"#DAA520");
$r->createRectangle(323,133,342,152,-fill=>"#DAA520");
$r->createRectangle(323,152,342,171,-fill=>"#DAA520");
$r->createRectangle(323,171,342,190,-fill=>"#DAA520");
$r->createRectangle(323,190,342,209,-fill=>"#DAA520");
$r->createRectangle(323,209,342,228,-fill=>'white');
$r->createRectangle(323,228,342,247,-fill=>'white');
$r->createRectangle(323,247,342,266,-fill=>'white');
$r->createRectangle(323,266,342,285,-fill=>'white');
$r->createRectangle(323,285,342,304,-fill=>'white');
$r->createRectangle(323,304,342,323,-fill=>'white');
$r->createRectangle(323,323,342,342,-fill=>'white');
$r->createRectangle(323,342,342,361,-fill=>'white');
$r->createRectangle(323,361,342,380,-fill=>"#DAA520");
$r->createRectangle(323,380,342,399,-fill=>"#DAA520");
$r->createRectangle(323,399,342,418,-fill=>"#DAA520");
$r->createRectangle(323,418,342,437,-fill=>"#DAA520");
$r->createRectangle(323,437,342,456,-fill=>"#DAA520");
$r->createRectangle(323,456,342,475,-fill=>"#DAA520");
$r->createRectangle(323,475,342,494,-fill=>'yellow');
$r->createRectangle(323,494,342,513,-fill=>"#DAA520");
$r->createRectangle(323,513,342,532,-fill=>"#DAA520");
$r->createRectangle(323,532,342,551,-fill=>"#DAA520");
$r->createRectangle(323,551,342,570,-fill=>'white');
$r->createRectangle(323,570,342,589,-fill=>'white');
$r->createRectangle(323,589,342,608,-fill=>'white');
$r->createRectangle(323,608,342,627,-fill=>'white');
$r->createRectangle(323,627,342,646,-fill=>'white');
$r->createRectangle(323,646,342,665,-fill=>'white');
$r->createRectangle(323,665,342,684,-fill=>'white');
#i=19;
$r->createRectangle(342,0,361,19,-fill=>'white');
$r->createRectangle(342,19,361,38,-fill=>'white');
$r->createRectangle(342,38,361,57,-fill=>"#DAA520");
$r->createRectangle(342,57,361,76,-fill=>"#DAA520");
$r->createRectangle(342,76,361,95,-fill=>"#DAA520");
$r->createRectangle(342,95,361,114,-fill=>"#DAA520");
$r->createRectangle(342,114,361,133,-fill=>"#DAA520");
$r->createRectangle(342,133,361,152,-fill=>"#DAA520");
$r->createRectangle(342,152,361,171,-fill=>"#DAA520");
$r->createRectangle(342,171,361,190,-fill=>"#DAA520");
$r->createRectangle(342,190,361,209,-fill=>"#DAA520");
$r->createRectangle(342,209,361,228,-fill=>'white');
$r->createRectangle(342,228,361,247,-fill=>'white');
$r->createRectangle(342,247,361,266,-fill=>'white');
$r->createRectangle(342,266,361,285,-fill=>'white');
$r->createRectangle(342,285,361,304,-fill=>'white');
$r->createRectangle(342,304,361,323,-fill=>'white');
$r->createRectangle(342,323,361,342,-fill=>'white');
$r->createRectangle(342,342,361,361,-fill=>'white');
$r->createRectangle(342,361,361,380,-fill=>"#DAA520");
$r->createRectangle(342,380,361,399,-fill=>"#DAA520");
$r->createRectangle(342,399,361,418,-fill=>"#DAA520");
$r->createRectangle(342,418,361,437,-fill=>"#DAA520");
$r->createRectangle(342,437,361,456,-fill=>"#DAA520");
$r->createRectangle(342,456,361,475,-fill=>"#DAA520");
$r->createRectangle(342,475,361,494,-fill=>'yellow');
$r->createRectangle(342,494,361,513,-fill=>"#DAA520");
$r->createRectangle(342,513,361,532,-fill=>"#DAA520");
$r->createRectangle(342,532,361,551,-fill=>"#DAA520");
$r->createRectangle(342,551,361,570,-fill=>'white');
$r->createRectangle(342,570,361,589,-fill=>'white');
$r->createRectangle(342,589,361,608,-fill=>'white');
$r->createRectangle(342,608,361,627,-fill=>'white');
$r->createRectangle(342,627,361,646,-fill=>'white');
$r->createRectangle(342,646,361,665,-fill=>'white');
$r->createRectangle(342,665,361,684,-fill=>'white');
#i=20;
$r->createRectangle(361,0,380,19,-fill=>'white');
$r->createRectangle(361,19,380,38,-fill=>'white');
$r->createRectangle(361,38,380,57,-fill=>'white');
$r->createRectangle(361,57,380,76,-fill=>'white');
$r->createRectangle(361,76,380,95,-fill=>'white');
$r->createRectangle(361,95,380,114,-fill=>'white');
$r->createRectangle(361,114,380,133,-fill=>'white');
$r->createRectangle(361,133,380,152,-fill=>"#DAA520");
$r->createRectangle(361,152,380,171,-fill=>"#DAA520");
$r->createRectangle(361,171,380,190,-fill=>"#DAA520");
$r->createRectangle(361,190,380,209,-fill=>"#DAA520");
$r->createRectangle(361,209,380,228,-fill=>"#DAA520");
$r->createRectangle(361,228,380,247,-fill=>"#DAA520");
$r->createRectangle(361,247,380,266,-fill=>"#DAA520");
$r->createRectangle(361,266,380,285,-fill=>"#DAA520");
$r->createRectangle(361,285,380,304,-fill=>"#DAA520");
$r->createRectangle(361,304,380,323,-fill=>'white');
$r->createRectangle(361,323,380,342,-fill=>'white');
$r->createRectangle(361,342,380,361,-fill=>'white');
$r->createRectangle(361,361,380,380,-fill=>'white');
$r->createRectangle(361,380,380,399,-fill=>'white');
$r->createRectangle(361,399,380,418,-fill=>"#DAA520");
$r->createRectangle(361,418,380,437,-fill=>"#DAA520");
$r->createRectangle(361,437,380,456,-fill=>"#DAA520");
$r->createRectangle(361,456,380,475,-fill=>"#DAA520");
$r->createRectangle(361,475,380,494,-fill=>"#DAA520");
$r->createRectangle(361,494,380,513,-fill=>"#DAA520");
$r->createRectangle(361,513,380,532,-fill=>"#DAA520");
$r->createRectangle(361,532,380,551,-fill=>"#DAA520");
$r->createRectangle(361,551,380,570,-fill=>'white');
$r->createRectangle(361,570,380,589,-fill=>'white');
$r->createRectangle(361,589,380,608,-fill=>'white');
$r->createRectangle(361,608,380,627,-fill=>'white');
$r->createRectangle(361,627,380,646,-fill=>'white');
$r->createRectangle(361,646,380,665,-fill=>'white');
$r->createRectangle(361,665,380,684,-fill=>'white');
#i=21;
$r->createRectangle(380,0,399,19,-fill=>"#DAA520");
$r->createRectangle(380,19,399,38,-fill=>'white');
$r->createRectangle(380,38,399,57,-fill=>'white');
$r->createRectangle(380,57,399,76,-fill=>'white');
$r->createRectangle(380,76,399,95,-fill=>'white');
$r->createRectangle(380,95,399,114,-fill=>'white');
$r->createRectangle(380,114,399,133,-fill=>'white');
$r->createRectangle(380,133,399,152,-fill=>"#DAA520");
$r->createRectangle(380,152,399,171,-fill=>"#DAA520");
$r->createRectangle(380,171,399,190,-fill=>"#DAA520");
$r->createRectangle(380,190,399,209,-fill=>"#DAA520");
$r->createRectangle(380,209,399,228,-fill=>"#DAA520");
$r->createRectangle(380,228,399,247,-fill=>"#DAA520");
$r->createRectangle(380,247,399,266,-fill=>"#DAA520");
$r->createRectangle(380,266,399,285,-fill=>"#DAA520");
$r->createRectangle(380,285,399,304,-fill=>"#DAA520");
$r->createRectangle(380,304,399,323,-fill=>"#DAA520");
$r->createRectangle(380,323,399,342,-fill=>"#DAA520");
$r->createRectangle(380,342,399,361,-fill=>"#DAA520");
$r->createRectangle(380,361,399,380,-fill=>"#DAA520");
$r->createRectangle(380,380,399,399,-fill=>"#DAA520");
$r->createRectangle(380,399,399,418,-fill=>'white');
$r->createRectangle(380,418,399,437,-fill=>'white');
$r->createRectangle(380,437,399,456,-fill=>"#DAA520");
$r->createRectangle(380,456,399,475,-fill=>"#DAA520");
$r->createRectangle(380,475,399,494,-fill=>"#DAA520");
$r->createRectangle(380,494,399,513,-fill=>"#DAA520");
$r->createRectangle(380,513,399,532,-fill=>"#DAA520");
$r->createRectangle(380,532,399,551,-fill=>'white');
$r->createRectangle(380,551,399,570,-fill=>'white');
$r->createRectangle(380,570,399,589,-fill=>'white');
$r->createRectangle(380,589,399,608,-fill=>'white');
$r->createRectangle(380,608,399,627,-fill=>'white');
$r->createRectangle(380,627,399,646,-fill=>'white');
$r->createRectangle(380,646,399,665,-fill=>'white');
$r->createRectangle(380,665,399,684,-fill=>'white');
#i=22;
$r->createRectangle(399,0,418,19,-fill=>"#DAA520");
$r->createRectangle(399,19,418,38,-fill=>'white');
$r->createRectangle(399,38,418,57,-fill=>'white');
$r->createRectangle(399,57,418,76,-fill=>'white');
$r->createRectangle(399,76,418,95,-fill=>'white');
$r->createRectangle(399,95,418,114,-fill=>'white');
$r->createRectangle(399,114,418,133,-fill=>'white');
$r->createRectangle(399,133,418,152,-fill=>"#DAA520");
$r->createRectangle(399,152,418,171,-fill=>"#DAA520");
$r->createRectangle(399,171,418,190,-fill=>'yellow');
$r->createRectangle(399,190,418,209,-fill=>'yellow');
$r->createRectangle(399,209,418,228,-fill=>"#DAA520");
$r->createRectangle(399,228,418,247,-fill=>'yellow');
$r->createRectangle(399,247,418,266,-fill=>'yellow');
$r->createRectangle(399,266,418,285,-fill=>"#DAA520");
$r->createRectangle(399,285,418,304,-fill=>"#DAA520");
$r->createRectangle(399,304,418,323,-fill=>"#DAA520");
$r->createRectangle(399,323,418,342,-fill=>"#DAA520");
$r->createRectangle(399,342,418,361,-fill=>"#DAA520");
$r->createRectangle(399,361,418,380,-fill=>"#DAA520");
$r->createRectangle(399,380,418,399,-fill=>"#DAA520");
$r->createRectangle(399,399,418,418,-fill=>'white');
$r->createRectangle(399,418,418,437,-fill=>'white');
$r->createRectangle(399,437,418,456,-fill=>'white');
$r->createRectangle(399,456,418,475,-fill=>'white');
$r->createRectangle(399,475,418,494,-fill=>'white');
$r->createRectangle(399,494,418,513,-fill=>'white');
$r->createRectangle(399,513,418,532,-fill=>'white');
$r->createRectangle(399,532,418,551,-fill=>'white');
$r->createRectangle(399,551,418,579,-fill=>"#DAA520");
$r->createRectangle(399,570,418,589,-fill=>"#DAA520");
$r->createRectangle(399,589,418,608,-fill=>"#DAA520");
$r->createRectangle(399,608,418,627,-fill=>"#DAA520");
$r->createRectangle(399,627,418,646,-fill=>"#DAA520");
$r->createRectangle(399,646,418,665,-fill=>"#DAA520");
$r->createRectangle(399,665,418,684,-fill=>"#DAA520");
#i=23;
$r->createRectangle(418,0,437,19,-fill=>"#DAA520");
$r->createRectangle(418,19,437,38,-fill=>'white');
$r->createRectangle(418,38,437,57,-fill=>'white');
$r->createRectangle(418,57,437,76,-fill=>'white');
$r->createRectangle(418,76,437,95,-fill=>'white');
$r->createRectangle(418,95,437,114,-fill=>'white');
$r->createRectangle(418,114,437,133,-fill=>"#DAA520");
$r->createRectangle(418,133,437,152,-fill=>"#DAA520");
$r->createRectangle(418,152,437,171,-fill=>"#DAA520");
$r->createRectangle(418,171,437,190,-fill=>'yellow');
$r->createRectangle(418,190,437,209,-fill=>'yellow');
$r->createRectangle(418,209,437,228,-fill=>'yellow');
$r->createRectangle(418,228,437,247,-fill=>'yellow');
$r->createRectangle(418,247,437,266,-fill=>'yellow');
$r->createRectangle(418,266,437,285,-fill=>'yellow');
$r->createRectangle(418,285,437,304,-fill=>'yellow');
$r->createRectangle(418,304,437,323,-fill=>"#DAA520");
$r->createRectangle(418,323,437,342,-fill=>"#DAA520");
$r->createRectangle(418,342,437,361,-fill=>"#DAA520");
$r->createRectangle(418,361,437,380,-fill=>"#DAA520");
$r->createRectangle(418,380,437,399,-fill=>"#DAA520");
$r->createRectangle(418,399,437,418,-fill=>'white');
$r->createRectangle(418,418,437,437,-fill=>'white');
$r->createRectangle(418,437,437,456,-fill=>'white');
$r->createRectangle(418,456,437,475,-fill=>'white');
$r->createRectangle(418,475,437,494,-fill=>'white');
$r->createRectangle(418,494,437,513,-fill=>'white');
$r->createRectangle(418,513,437,532,-fill=>'white');
$r->createRectangle(418,532,437,551,-fill=>'white');
$r->createRectangle(418,551,437,570,-fill=>'white');
$r->createRectangle(418,570,437,589,-fill=>"#DAA520");
$r->createRectangle(418,589,437,608,-fill=>"#DAA520");
$r->createRectangle(418,608,437,627,-fill=>"#DAA520");
$r->createRectangle(418,627,437,646,-fill=>"#DAA520");
$r->createRectangle(418,646,437,665,-fill=>"#DAA520");
$r->createRectangle(418,665,437,684,-fill=>"#DAA520");
#i=24;
$r->createRectangle(437,0,456,19,-fill=>"#DAA520");
$r->createRectangle(437,19,456,38,-fill=>'white');
$r->createRectangle(437,38,456,57,-fill=>'white');
$r->createRectangle(437,57,456,76,-fill=>'white');
$r->createRectangle(437,76,456,95,-fill=>'white');
$r->createRectangle(437,95,456,114,-fill=>'white');
$r->createRectangle(437,114,456,133,-fill=>"#DAA520");
$r->createRectangle(437,133,456,152,-fill=>"#DAA520");
$r->createRectangle(437,152,456,171,-fill=>"#DAA520");
$r->createRectangle(437,171,456,190,-fill=>'yellow');
$r->createRectangle(437,190,456,209,-fill=>'yellow');
$r->createRectangle(437,209,456,228,-fill=>'yellow');
$r->createRectangle(437,228,456,247,-fill=>'yellow');
$r->createRectangle(437,247,456,266,-fill=>'red');
$r->createRectangle(437,266,456,285,-fill=>'red');
$r->createRectangle(437,285,456,304,-fill=>'yellow');
$r->createRectangle(437,304,456,323,-fill=>'yellow');
$r->createRectangle(437,323,456,342,-fill=>"#DAA520");
$r->createRectangle(437,342,456,361,-fill=>'yellow');
$r->createRectangle(437,361,456,380,-fill=>"#DAA520");
$r->createRectangle(437,380,456,399,-fill=>"#DAA520");
$r->createRectangle(437,399,456,418,-fill=>'white');
$r->createRectangle(437,418,456,437,-fill=>'white');
$r->createRectangle(437,437,456,456,-fill=>'white');
$r->createRectangle(437,456,456,475,-fill=>'white');
$r->createRectangle(437,475,456,494,-fill=>'white');
$r->createRectangle(437,494,456,513,-fill=>'white');
$r->createRectangle(437,513,456,532,-fill=>'white');
$r->createRectangle(437,532,456,551,-fill=>'white');
$r->createRectangle(437,551,456,570,-fill=>'white');
$r->createRectangle(437,570,456,589,-fill=>"#DAA520");
$r->createRectangle(437,589,456,608,-fill=>"#DAA520");
$r->createRectangle(437,608,456,627,-fill=>'yellow');
$r->createRectangle(437,627,456,646,-fill=>'yellow');
$r->createRectangle(437,646,456,665,-fill=>'yellow');
$r->createRectangle(437,665,456,684,-fill=>"#DAA520");
#i=25;
$r->createRectangle(456,0,475,19,-fill=>"#DAA520");
$r->createRectangle(456,19,475,38,-fill=>'white');
$r->createRectangle(456,38,475,57,-fill=>'white');
$r->createRectangle(456,57,475,76,-fill=>'white');
$r->createRectangle(456,76,475,95,-fill=>'white');
$r->createRectangle(456,95,475,114,-fill=>'white');
$r->createRectangle(456,114,475,133,-fill=>"#DAA520");
$r->createRectangle(456,133,475,152,-fill=>"#DAA520");
$r->createRectangle(456,152,475,171,-fill=>'yellow');
$r->createRectangle(456,171,475,290,-fill=>'yellow');
$r->createRectangle(456,190,475,209,-fill=>'yellow');
$r->createRectangle(456,209,475,228,-fill=>'yellow');
$r->createRectangle(456,228,475,247,-fill=>'yellow');
$r->createRectangle(456,247,475,266,-fill=>'yellow');
$r->createRectangle(456,266,475,285,-fill=>'red');
$r->createRectangle(456,285,475,304,-fill=>'yellow');
$r->createRectangle(456,304,475,323,-fill=>'yellow');
$r->createRectangle(456,323,475,342,-fill=>'yellow');
$r->createRectangle(456,342,475,361,-fill=>"#DAA520");
$r->createRectangle(456,361,475,380,-fill=>"#DAA520");
$r->createRectangle(456,380,475,399,-fill=>"#DAA520");
$r->createRectangle(456,399,475,418,-fill=>'white');
$r->createRectangle(456,418,475,437,-fill=>'white');
$r->createRectangle(456,437,475,456,-fill=>'white');
$r->createRectangle(456,456,475,475,-fill=>'white');
$r->createRectangle(456,475,475,494,-fill=>'white');
$r->createRectangle(456,494,475,513,-fill=>'white');
$r->createRectangle(456,513,475,532,-fill=>'white');
$r->createRectangle(456,532,475,551,-fill=>'white');
$r->createRectangle(456,551,475,570,-fill=>'white');
$r->createRectangle(456,570,475,589,-fill=>"#DAA520");
$r->createRectangle(456,589,475,608,-fill=>"#DAA520");
$r->createRectangle(456,608,475,627,-fill=>"#DAA520");
$r->createRectangle(456,627,475,646,-fill=>"#DAA520");
$r->createRectangle(456,646,475,665,-fill=>'yellow');
$r->createRectangle(456,665,475,684,-fill=>"#DAA520");
#i=26;
$r->createRectangle(475,0,494,19,-fill=>"#DAA520");
$r->createRectangle(475,19,494,38,-fill=>'white');
$r->createRectangle(475,38,494,57,-fill=>'white');
$r->createRectangle(475,57,494,76,-fill=>'white');
$r->createRectangle(475,76,494,95,-fill=>'white');
$r->createRectangle(475,95,494,114,-fill=>'white');
$r->createRectangle(475,114,494,133,-fill=>"#DAA520");
$r->createRectangle(475,133,494,152,-fill=>"#DAA520");
$r->createRectangle(475,152,494,171,-fill=>'yellow');
$r->createRectangle(475,171,494,190,-fill=>"#DAA520");
$r->createRectangle(475,190,494,209,-fill=>"#DAA520");
$r->createRectangle(475,209,494,228,-fill=>"#DAA520");
$r->createRectangle(475,228,494,247,-fill=>'yellow');
$r->createRectangle(475,247,494,266,-fill=>'yellow');
$r->createRectangle(475,266,494,285,-fill=>'yellow');
$r->createRectangle(475,285,494,304,-fill=>'yellow');
$r->createRectangle(475,304,494,323,-fill=>'yellow');
$r->createRectangle(475,323,494,342,-fill=>'yellow');
$r->createRectangle(475,342,494,361,-fill=>'yellow');
$r->createRectangle(475,361,494,380,-fill=>"#DAA520");
$r->createRectangle(475,380,494,399,-fill=>"#DAA520");
$r->createRectangle(475,399,494,418,-fill=>'white');
$r->createRectangle(475,418,494,437,-fill=>'white');
$r->createRectangle(475,437,494,456,-fill=>'white');
$r->createRectangle(475,456,494,475,-fill=>'white');
$r->createRectangle(475,475,494,494,-fill=>'white');
$r->createRectangle(475,494,494,513,-fill=>'white');
$r->createRectangle(475,513,494,532,-fill=>'white');
$r->createRectangle(475,532,494,551,-fill=>'white');
$r->createRectangle(475,551,494,570,-fill=>'white');
$r->createRectangle(475,570,494,589,-fill=>"#DAA520");
$r->createRectangle(475,589,494,608,-fill=>"#DAA520");
$r->createRectangle(475,608,494,627,-fill=>"#DAA520");
$r->createRectangle(475,627,494,646,-fill=>"#DAA520");
$r->createRectangle(475,646,494,665,-fill=>"#DAA520");
$r->createRectangle(475,665,494,684,-fill=>"#DAA520");
#i=27;
$r->createRectangle(494,0,513,19,-fill=>'white');
$r->createRectangle(494,19,513,38,-fill=>'white');
$r->createRectangle(494,38,513,57,-fill=>'white');
$r->createRectangle(494,57,513,76,-fill=>'white');
$r->createRectangle(494,76,513,95,-fill=>'white');
$r->createRectangle(494,95,513,114,-fill=>'white');
$r->createRectangle(494,114,513,133,-fill=>"#DAA520");
$r->createRectangle(494,133,513,152,-fill=>"#DAA520");
$r->createRectangle(494,152,513,171,-fill=>"#DAA520");
$r->createRectangle(494,171,513,190,-fill=>"#DAA520");
$r->createRectangle(494,190,513,209,-fill=>"#DAA520");
$r->createRectangle(494,209,513,228,-fill=>"#DAA520");
$r->createRectangle(494,228,513,247,-fill=>'yellow');
$r->createRectangle(494,247,513,266,-fill=>"#DAA520");
$r->createRectangle(494,266,513,285,-fill=>"#DAA520");
$r->createRectangle(494,285,513,304,-fill=>'yellow');
$r->createRectangle(494,304,513,323,-fill=>"#DAA520");
$r->createRectangle(494,323,513,342,-fill=>'yellow');
$r->createRectangle(494,342,513,361,-fill=>'yellow');
$r->createRectangle(494,361,513,380,-fill=>"#DAA520");
$r->createRectangle(494,380,513,399,-fill=>"#DAA520");
$r->createRectangle(494,399,513,418,-fill=>'white');
$r->createRectangle(494,418,513,437,-fill=>'white');
$r->createRectangle(494,437,513,456,-fill=>'white');
$r->createRectangle(494,456,513,475,-fill=>'white');
$r->createRectangle(494,475,513,494,-fill=>'white');
$r->createRectangle(494,494,513,513,-fill=>'white');
$r->createRectangle(494,513,513,532,-fill=>'white');
$r->createRectangle(494,532,513,551,-fill=>'white');
$r->createRectangle(494,551,513,570,-fill=>'white');
$r->createRectangle(494,570,513,589,-fill=>'white');
$r->createRectangle(494,589,513,608,-fill=>'white');
$r->createRectangle(494,608,513,627,-fill=>"#DAA520");
$r->createRectangle(494,627,513,646,-fill=>"#DAA520");
$r->createRectangle(494,646,513,665,-fill=>"#DAA520");
$r->createRectangle(494,665,513,684,-fill=>"#DAA520");
#i=28;
$r->createRectangle(513,0,532,19,-fill=>'white');
$r->createRectangle(513,19,532,38,-fill=>'white');
$r->createRectangle(513,38,532,57,-fill=>'white');
$r->createRectangle(513,57,532,76,-fill=>'white');
$r->createRectangle(513,76,532,95,-fill=>'white');
$r->createRectangle(513,95,532,114,-fill=>'white');
$r->createRectangle(513,114,532,133,-fill=>"#DAA520");
$r->createRectangle(513,133,532,152,-fill=>"#DAA520");
$r->createRectangle(513,152,532,171,-fill=>"#DAA520");
$r->createRectangle(513,171,532,190,-fill=>"#DAA520");
$r->createRectangle(513,190,532,209,-fill=>"#DAA520");
$r->createRectangle(513,209,532,228,-fill=>"#DAA520");
$r->createRectangle(513,228,532,247,-fill=>"#DAA520");
$r->createRectangle(513,247,532,266,-fill=>"#DAA520");
$r->createRectangle(513,266,532,285,-fill=>"#DAA520");
$r->createRectangle(513,285,532,304,-fill=>"#DAA520");
$r->createRectangle(513,304,532,323,-fill=>"#DAA520");
$r->createRectangle(513,323,532,342,-fill=>"#DAA520");
$r->createRectangle(513,342,532,361,-fill=>"#DAA520");
$r->createRectangle(513,361,532,380,-fill=>"#DAA520");
$r->createRectangle(513,380,532,399,-fill=>"#DAA520");
$r->createRectangle(513,399,532,418,-fill=>'white');
$r->createRectangle(513,418,532,437,-fill=>'white');
$r->createRectangle(513,437,532,456,-fill=>'white');
$r->createRectangle(513,456,532,475,-fill=>'white');
$r->createRectangle(513,475,532,494,-fill=>'white');
$r->createRectangle(513,494,532,513,-fill=>'white');
$r->createRectangle(513,513,532,532,-fill=>'white');
$r->createRectangle(513,532,532,551,-fill=>'white');
$r->createRectangle(513,551,532,570,-fill=>'white');
$r->createRectangle(513,570,532,589,-fill=>'white');
$r->createRectangle(513,589,532,608,-fill=>'white');
$r->createRectangle(513,608,532,627,-fill=>'white');
$r->createRectangle(513,627,532,646,-fill=>'white');
$r->createRectangle(513,646,532,665,-fill=>'white');
$r->createRectangle(513,665,532,684,-fill=>'white');
#i=29;
$r->createRectangle(532,0,551,19,-fill=>'white');
$r->createRectangle(532,19,551,38,-fill=>'white');
$r->createRectangle(532,38,551,57,-fill=>'white');
$r->createRectangle(532,57,551,76,-fill=>'white');
$r->createRectangle(532,76,551,95,-fill=>'white');
$r->createRectangle(532,95,551,114,-fill=>'white');
$r->createRectangle(532,114,551,133,-fill=>'white');
$r->createRectangle(532,133,551,152,-fill=>'white');
$r->createRectangle(532,152,551,171,-fill=>'white');
$r->createRectangle(532,171,551,190,-fill=>'white');
$r->createRectangle(532,190,551,209,-fill=>'white');
$r->createRectangle(532,209,551,228,-fill=>"#DAA520");
$r->createRectangle(532,228,551,247,-fill=>"#DAA520");
$r->createRectangle(532,247,551,266,-fill=>"#DAA520");
$r->createRectangle(532,266,551,285,-fill=>"#DAA520");
$r->createRectangle(532,285,551,304,-fill=>"#DAA520");
$r->createRectangle(532,304,551,323,-fill=>"#DAA520");
$r->createRectangle(532,323,551,342,-fill=>"#DAA520");
$r->createRectangle(532,342,551,361,-fill=>"#DAA520");
$r->createRectangle(532,361,551,380,-fill=>"#DAA520");
$r->createRectangle(532,380,551,399,-fill=>"#DAA520");
$r->createRectangle(532,399,551,418,-fill=>'white');
$r->createRectangle(532,418,551,437,-fill=>'white');
$r->createRectangle(532,437,551,456,-fill=>'white');
$r->createRectangle(532,456,551,475,-fill=>'white');
$r->createRectangle(532,475,551,494,-fill=>'white');
$r->createRectangle(532,494,551,513,-fill=>'white');
$r->createRectangle(532,513,551,532,-fill=>'white');
$r->createRectangle(532,532,551,551,-fill=>'white');
$r->createRectangle(532,551,551,570,-fill=>'white');
$r->createRectangle(532,570,551,589,-fill=>'white');
$r->createRectangle(532,589,551,608,-fill=>'white');
$r->createRectangle(532,608,551,627,-fill=>'white');
$r->createRectangle(532,627,551,646,-fill=>'white');
$r->createRectangle(532,646,551,665,-fill=>'white');
$r->createRectangle(532,665,551,684,-fill=>'white');
#i=30;
$r->createRectangle(551,0,570,19,-fill=>'white');
$r->createRectangle(551,19,570,38,-fill=>'white');
$r->createRectangle(551,38,570,57,-fill=>'white');
$r->createRectangle(551,57,570,76,-fill=>'white');
$r->createRectangle(551,76,570,95,-fill=>'white');
$r->createRectangle(551,95,570,114,-fill=>'white');
$r->createRectangle(551,114,570,133,-fill=>'white');
$r->createRectangle(551,133,570,152,-fill=>'white');
$r->createRectangle(551,152,570,171,-fill=>'white');
$r->createRectangle(551,171,570,190,-fill=>'white');
$r->createRectangle(551,190,570,209,-fill=>'white');
$r->createRectangle(551,209,570,228,-fill=>'white');
$r->createRectangle(551,228,570,247,-fill=>'white');
$r->createRectangle(551,247,570,266,-fill=>'white');
$r->createRectangle(551,266,570,285,-fill=>'white');
$r->createRectangle(551,285,570,304,-fill=>'white');
$r->createRectangle(551,304,570,323,-fill=>'white');
$r->createRectangle(551,323,570,342,-fill=>'white');
$r->createRectangle(551,342,570,361,-fill=>'white');
$r->createRectangle(551,361,570,380,-fill=>'white');
$r->createRectangle(551,380,570,399,-fill=>'white');
$r->createRectangle(551,399,570,418,-fill=>'white');
$r->createRectangle(551,418,570,437,-fill=>'white');
$r->createRectangle(551,437,570,456,-fill=>'white');
$r->createRectangle(551,456,570,475,-fill=>'white');
$r->createRectangle(551,475,570,494,-fill=>'white');
$r->createRectangle(551,494,570,513,-fill=>'white');
$r->createRectangle(551,513,570,532,-fill=>'white');
$r->createRectangle(551,532,570,551,-fill=>'white');
$r->createRectangle(551,551,570,570,-fill=>'white');
$r->createRectangle(551,570,570,589,-fill=>'white');
$r->createRectangle(551,589,570,608,-fill=>'white');
$r->createRectangle(551,608,570,627,-fill=>'white');
$r->createRectangle(551,627,570,646,-fill=>'white');
$r->createRectangle(551,646,570,665,-fill=>'white');
$r->createRectangle(551,665,570,684,-fill=>'white');
#i=31;
$r->createRectangle(570,0,589,19,-fill=>'white');
$r->createRectangle(570,19,589,38,-fill=>'white');
$r->createRectangle(570,38,589,57,-fill=>'white');
$r->createRectangle(570,57,589,76,-fill=>'white');
$r->createRectangle(570,76,589,95,-fill=>'white');
$r->createRectangle(570,95,589,114,-fill=>'white');
$r->createRectangle(570,114,589,133,-fill=>'white');
$r->createRectangle(570,133,589,152,-fill=>'white');
$r->createRectangle(570,152,589,171,-fill=>'white');
$r->createRectangle(570,171,589,190,-fill=>'white');
$r->createRectangle(570,190,589,209,-fill=>'white');
$r->createRectangle(570,209,589,228,-fill=>'white');
$r->createRectangle(570,228,589,247,-fill=>'white');
$r->createRectangle(570,247,589,266,-fill=>'white');
$r->createRectangle(570,266,589,285,-fill=>'white');
$r->createRectangle(570,285,589,304,-fill=>'white');
$r->createRectangle(570,304,589,323,-fill=>'white');
$r->createRectangle(570,323,589,342,-fill=>'white');
$r->createRectangle(570,342,589,361,-fill=>'white');
$r->createRectangle(570,361,589,380,-fill=>'white');
$r->createRectangle(570,380,589,399,-fill=>'white');
$r->createRectangle(570,399,589,418,-fill=>'white');
$r->createRectangle(570,418,589,437,-fill=>'white');
$r->createRectangle(570,437,589,456,-fill=>'white');
$r->createRectangle(570,456,589,475,-fill=>'white');
$r->createRectangle(570,475,589,494,-fill=>'white');
$r->createRectangle(570,494,589,513,-fill=>'white');
$r->createRectangle(570,513,589,532,-fill=>'white');
$r->createRectangle(570,532,589,551,-fill=>'white');
$r->createRectangle(570,551,589,570,-fill=>'white');
$r->createRectangle(570,570,589,589,-fill=>'white');
$r->createRectangle(570,589,589,608,-fill=>'white');
$r->createRectangle(570,608,589,627,-fill=>'white');
$r->createRectangle(570,627,589,646,-fill=>'white');
$r->createRectangle(570,646,589,665,-fill=>'white');
$r->createRectangle(570,665,589,684,-fill=>'white');
#i=32;
$r->createRectangle(589,0,608,19,-fill=>"#DAA520");
$r->createRectangle(589,19,608,38,-fill=>"#DAA520");
$r->createRectangle(589,38,608,57,-fill=>"#DAA520");
$r->createRectangle(589,57,608,76,-fill=>"#DAA520");
$r->createRectangle(589,76,608,95,-fill=>"#DAA520");
$r->createRectangle(589,95,608,114,-fill=>'white');
$r->createRectangle(589,114,608,133,-fill=>'white');
$r->createRectangle(589,133,608,152,-fill=>'white');
$r->createRectangle(589,152,608,171,-fill=>'white');
$r->createRectangle(589,171,608,190,-fill=>'white');
$r->createRectangle(589,190,608,209,-fill=>'white');
$r->createRectangle(589,209,608,228,-fill=>'white');
$r->createRectangle(589,228,608,247,-fill=>'white');
$r->createRectangle(589,247,608,266,-fill=>'white');
$r->createRectangle(589,266,608,285,-fill=>'white');
$r->createRectangle(589,285,608,304,-fill=>'white');
$r->createRectangle(589,304,608,323,-fill=>'white');
$r->createRectangle(589,323,608,342,-fill=>'white');
$r->createRectangle(589,342,608,361,-fill=>'white');
$r->createRectangle(589,361,608,380,-fill=>'white');
$r->createRectangle(589,380,608,399,-fill=>'white');
$r->createRectangle(589,399,608,418,-fill=>'white');
$r->createRectangle(589,418,608,437,-fill=>'white');
$r->createRectangle(589,437,608,456,-fill=>'white');
$r->createRectangle(589,456,608,475,-fill=>'white');
$r->createRectangle(589,475,608,494,-fill=>'white');
$r->createRectangle(589,494,608,513,-fill=>'white');
$r->createRectangle(589,513,608,532,-fill=>'white');
$r->createRectangle(589,532,608,551,-fill=>'white');
$r->createRectangle(589,551,608,570,-fill=>'white');
$r->createRectangle(589,570,608,589,-fill=>'white');
$r->createRectangle(589,589,608,608,-fill=>'white');
$r->createRectangle(589,608,608,627,-fill=>'white');
$r->createRectangle(589,627,608,646,-fill=>'white');
$r->createRectangle(589,646,608,665,-fill=>'white');
$r->createRectangle(589,665,608,684,-fill=>'white');
#i=33;
$r->createRectangle(608,0,627,19,-fill=>"#DAA520");
$r->createRectangle(608,19,627,38,-fill=>"#DAA520");
$r->createRectangle(608,38,627,57,-fill=>"#DAA520");
$r->createRectangle(608,57,627,76,-fill=>"#DAA520");
$r->createRectangle(608,76,627,95,-fill=>"#DAA520");
$r->createRectangle(608,95,627,114,-fill=>"#DAA520");
$r->createRectangle(608,114,627,133,-fill=>'white');
$r->createRectangle(608,133,627,152,-fill=>'white');
$r->createRectangle(608,152,627,171,-fill=>'white');
$r->createRectangle(608,171,627,190,-fill=>'white');
$r->createRectangle(608,190,627,209,-fill=>'white');
$r->createRectangle(608,209,627,228,-fill=>'white');
$r->createRectangle(608,228,627,247,-fill=>'white');
$r->createRectangle(608,247,627,266,-fill=>'white');
$r->createRectangle(608,266,627,285,-fill=>'white');
$r->createRectangle(608,285,627,304,-fill=>'white');
$r->createRectangle(608,304,627,323,-fill=>'white');
$r->createRectangle(608,323,627,342,-fill=>'white');
$r->createRectangle(608,342,627,361,-fill=>'white');
$r->createRectangle(608,361,627,380,-fill=>'white');
$r->createRectangle(608,380,627,399,-fill=>'white');
$r->createRectangle(608,399,627,418,-fill=>'white');
$r->createRectangle(608,418,627,437,-fill=>'white');
$r->createRectangle(608,437,627,456,-fill=>'white');
$r->createRectangle(608,456,627,475,-fill=>'white');
$r->createRectangle(608,475,627,494,-fill=>'white');
$r->createRectangle(608,494,627,513,-fill=>'white');
$r->createRectangle(608,513,627,532,-fill=>'white');
$r->createRectangle(608,532,627,551,-fill=>'white');
$r->createRectangle(608,551,627,570,-fill=>'white');
$r->createRectangle(608,570,627,589,-fill=>'white');
$r->createRectangle(608,589,627,608,-fill=>'white');
$r->createRectangle(608,608,627,627,-fill=>'white');
$r->createRectangle(608,627,627,646,-fill=>'white');
$r->createRectangle(608,646,627,665,-fill=>'white');
$r->createRectangle(608,665,627,684,-fill=>'white');
#i=34;
$r->createRectangle(627,0,646,19,-fill=>"#DAA520");
$r->createRectangle(627,19,646,38,-fill=>"#DAA520");
$r->createRectangle(627,38,646,57,-fill=>'yellow');
$r->createRectangle(627,57,646,76,-fill=>"#DAA520");
$r->createRectangle(627,76,646,95,-fill=>"#DAA520");
$r->createRectangle(627,95,646,114,-fill=>"#DAA520");
$r->createRectangle(627,114,646,133,-fill=>"#DAA520");
$r->createRectangle(627,133,646,152,-fill=>"#DAA520");
$r->createRectangle(627,152,646,171,-fill=>"#DAA520");
$r->createRectangle(627,171,646,190,-fill=>"#DAA520");
$r->createRectangle(627,190,646,209,-fill=>"#DAA520");
$r->createRectangle(627,209,646,228,-fill=>"#DAA520");
$r->createRectangle(627,228,646,247,-fill=>"#DAA520");
$r->createRectangle(627,247,646,266,-fill=>"#DAA520");
$r->createRectangle(627,266,646,285,-fill=>"#DAA520");
$r->createRectangle(627,285,646,530,-fill=>"#DAA520");
$r->createRectangle(627,304,646,323,-fill=>"#DAA520");
$r->createRectangle(627,323,646,342,-fill=>"#DAA520");
$r->createRectangle(627,342,646,361,-fill=>"#DAA520");
$r->createRectangle(627,361,646,380,-fill=>"#DAA520");
$r->createRectangle(627,380,646,399,-fill=>"#DAA520");
$r->createRectangle(627,399,646,418,-fill=>"#DAA520");
$r->createRectangle(627,418,646,437,-fill=>"#DAA520");
$r->createRectangle(627,437,646,456,-fill=>"#DAA520");
$r->createRectangle(627,456,646,475,-fill=>"#DAA520");
$r->createRectangle(627,475,646,494,-fill=>"#DAA520");
$r->createRectangle(627,494,646,513,-fill=>"#DAA520");
$r->createRectangle(627,513,646,532,-fill=>'white');
$r->createRectangle(627,532,646,551,-fill=>'white');
$r->createRectangle(627,551,646,570,-fill=>'white');
$r->createRectangle(627,570,646,589,-fill=>'white');
$r->createRectangle(627,589,646,608,-fill=>'white');
$r->createRectangle(627,608,646,627,-fill=>'white');
$r->createRectangle(627,627,646,646,-fill=>"#DAA520");
$r->createRectangle(627,646,646,665,-fill=>"#DAA520");
$r->createRectangle(627,665,646,684,-fill=>"#DAA520");
#i=35;
$r->createRectangle(646,0,665,19,-fill=>"#DAA520");
$r->createRectangle(646,19,665,38,-fill=>'yellow');
$r->createRectangle(646,38,665,57,-fill=>'yellow');
$r->createRectangle(646,57,665,76,-fill=>'yellow');
$r->createRectangle(646,76,665,95,-fill=>"#DAA520");
$r->createRectangle(646,95,665,114,-fill=>"#DAA520");
$r->createRectangle(646,114,665,133,-fill=>"#DAA520");
$r->createRectangle(646,133,665,152,-fill=>"#DAA520");
$r->createRectangle(646,152,665,171,-fill=>"#DAA520");
$r->createRectangle(646,171,665,190,-fill=>"#DAA520");
$r->createRectangle(646,190,665,209,-fill=>"#DAA520");
$r->createRectangle(646,209,665,228,-fill=>"#DAA520");
$r->createRectangle(646,228,665,247,-fill=>"#DAA520");
$r->createRectangle(646,247,665,266,-fill=>"#DAA520");
$r->createRectangle(646,266,665,285,-fill=>"#DAA520");
$r->createRectangle(646,285,665,304,-fill=>"#DAA520");
$r->createRectangle(646,304,665,323,-fill=>"#DAA520");
$r->createRectangle(646,323,665,342,-fill=>"#DAA520");
$r->createRectangle(646,342,665,361,-fill=>"#DAA520");
$r->createRectangle(646,361,665,380,-fill=>"#DAA520");
$r->createRectangle(646,380,665,399,-fill=>"#DAA520");
$r->createRectangle(646,399,665,418,-fill=>"#DAA520");
$r->createRectangle(646,418,665,437,-fill=>"#DAA520");
$r->createRectangle(646,437,665,456,-fill=>"#DAA520");
$r->createRectangle(646,456,665,475,-fill=>"#DAA520");
$r->createRectangle(646,475,665,494,-fill=>"#DAA520");
$r->createRectangle(646,494,665,513,-fill=>"#DAA520");
$r->createRectangle(646,513,665,532,-fill=>'white');
$r->createRectangle(646,532,665,551,-fill=>'white');
$r->createRectangle(646,551,665,570,-fill=>'white');
$r->createRectangle(646,570,665,589,-fill=>'white');
$r->createRectangle(646,589,665,608,-fill=>'white');
$r->createRectangle(646,608,665,627,-fill=>'white');
$r->createRectangle(646,627,665,646,-fill=>"#DAA520");
$r->createRectangle(646,646,665,665,-fill=>"#DAA520");
$r->createRectangle(646,665,665,684,-fill=>"#DAA520");
#$i=36;
$r->createRectangle(665,0,684,19,-fill=>'yellow');
$r->createRectangle(665,19,684,38,-fill=>'yellow');
$r->createRectangle(665,38,684,57,-fill=>'yellow');
$r->createRectangle(665,57,684,76,-fill=>'yellow');
$r->createRectangle(665,76,684,95,-fill=>'yellow');
$r->createRectangle(665,95,684,114,-fill=>'yellow');
$r->createRectangle(665,114,684,133,-fill=>'yellow');
$r->createRectangle(665,133,684,152,-fill=>'yellow');
$r->createRectangle(665,152,684,171,-fill=>'yellow');
$r->createRectangle(665,171,684,190,-fill=>"#DAA520");
$r->createRectangle(665,190,684,209,-fill=>"#DAA520");
$r->createRectangle(665,209,684,228,-fill=>"#DAA520");
$r->createRectangle(665,228,684,247,-fill=>"#DAA520");
$r->createRectangle(665,247,684,266,-fill=>"#DAA520");
$r->createRectangle(665,266,684,285,-fill=>"#DAA520");
$r->createRectangle(665,285,684,304,-fill=>"#DAA520");
$r->createRectangle(665,304,684,323,-fill=>"#DAA520");
$r->createRectangle(665,323,684,342,-fill=>"#DAA520");
$r->createRectangle(665,342,684,361,-fill=>"#DAA520");
$r->createRectangle(665,361,684,380,-fill=>"#DAA520");
$r->createRectangle(665,380,684,399,-fill=>"#DAA520");
$r->createRectangle(665,399,684,418,-fill=>"#DAA520");
$r->createRectangle(665,418,684,437,-fill=>"#DAA520");
$r->createRectangle(665,437,684,456,-fill=>"#DAA520");
$r->createRectangle(665,456,684,475,-fill=>"#DAA520");
$r->createRectangle(665,475,684,494,-fill=>"#DAA520");
$r->createRectangle(665,494,684,513,-fill=>"#DAA520");
$r->createRectangle(665,513,684,532,-fill=>'white');
$r->createRectangle(665,532,684,551,-fill=>'white');
$r->createRectangle(665,551,684,570,-fill=>'white');
$r->createRectangle(665,570,684,589,-fill=>'white');
$r->createRectangle(665,589,684,608,-fill=>'white');
$r->createRectangle(665,608,684,627,-fill=>'white');
$r->createRectangle(665,627,684,646,-fill=>"#DAA520");
$r->createRectangle(665,646,684,665,-fill=>"#DAA520");
$r->createRectangle(665,665,684,684,-fill=>'yellow');
$r->createText(10,10,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(670,670,-fill =>'black',-text =>"180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(15,670,-fill =>'black',-text =>"-180",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(343,670,-fill =>'black',-text =>"Phi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
$r->createText(40,343,-fill =>'black',-text =>"Psi(degrees)",-font=>[-size =>'10',-weight =>'bold',]); 
open(FH,$m);
@rn=();@nx=();@ny=();@nz=();@rca=();@cax=();@cay=();@caz=();@rc=();@cx=();@cy=();@cz=();
@resname=();
$nc=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ram)
{
if(substr($_,13,3) eq 'N  ')
{
$nc++;
push(@resname,substr($_,17,3));
push(@rn,substr($_,23,3));
push(@nx,substr($_,31,7));
push(@ny,substr($_,39,7));
push(@nz,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rca,substr($_,23,3));
push(@cax,substr($_,31,7));
push(@cay,substr($_,39,7));
push(@caz,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rc,substr($_,23,3));
push(@cx,substr($_,31,7));
push(@cy,substr($_,39,7));
push(@cz,substr($_,47,7));
}
}
}
}
@v1x=();@v1y=();@v1z=();
@v2x=();@v2y=();@v2z=();
@v3x=();@v3y=();@v3z=();
for($i=1;$i<$nc;$i++)
{
push(@v1x,$nx[$i]-$cx[$i-1]);
push(@v1y,$ny[$i]-$cy[$i-1]);
push(@v1z,$nz[$i]-$cz[$i-1]);
push(@v2x,$cax[$i]-$nx[$i]);
push(@v2y,$cay[$i]-$ny[$i]);
push(@v2z,$caz[$i]-$nz[$i]);
push(@v3x,$cx[$i]-$cax[$i]);
push(@v3y,$cy[$i]-$cay[$i]);
push(@v3z,$cz[$i]-$caz[$i]);
}
@pyz=();@pxz=();@pxy=();
@qyz=();@qxz=();@qxy=();
for($i=0;$i<$nc;$i++)
{
push(@pyz,$v1y[$i]*$v2z[$i]-$v1z[$i]*$v2y[$i]);
push(@pxz,$v1z[$i]*$v2x[$i]-$v1x[$i]*$v2z[$i]);
push(@pxy,$v1x[$i]*$v2y[$i]-$v1y[$i]*$v2x[$i]);
push(@qyz,$v2y[$i]*$v3z[$i]-$v2z[$i]*$v3y[$i]);
push(@qxz,$v2z[$i]*$v3x[$i]-$v2x[$i]*$v3z[$i]);
push(@qxy,$v2x[$i]*$v3y[$i]-$v2y[$i]*$v3x[$i]);
}

@r1=();@r2=();@r3=();
for($i=0;$i<$nc;$i++)
{
push(@r1,$pzx[$i]*$qxy[$i]-$pxy[$i]*$qzx[$i]);
push(@r2,$pxy[$i]*$qyz[$i]-$pyz[$i]*$qxy[$i]);
push(@r3,$pyz[$i]*$qzx[$i]-$pzx[$i]*$qyz[$i]);
}

@l=();@lp=();@lq=();@cosval=();@sinval=();@angle=();
for($i=0;$i<$nc-1;$i++)
{
$sum[$i]=$pyz[$i]*$qyz[$i]+$pxz[$i]*$qxz[$i]+$pxy[$i]*$qxy[$i];
$lp[$i]=sqrt($pyz[$i]*$pyz[$i]+$pxz[$i]*$pxz[$i]+$pxy[$i]*$pxy[$i]);
$lq[$i]=sqrt($qyz[$i]*$qyz[$i]+$qxz[$i]*$qxz[$i]+$qxy[$i]*$qxy[$i]);
$l[$i]=$lp[$i]*$lq[$i];
}
for($i=0;$i<$nc-1;$i++)
{
$cosval[$i]+=$sum[$i]/$l[$i];
$sinsqval[$i]=1-($cosval[$i]*$cosval[$i]);
if($sinsqval[$i]<0)
{
$sinsqval[$i]=0;
}
$sinval[$i]=sqrt($sinsqval[$i]);
$angle[$i]=-(atan2($sinval[$i],$cosval[$i])*57.29578);
}
@sum1=();
for($i=0;$i<$nc-1;$i++)
{
$sum1[$i]=$r1[$i]*$v2x[$i]+$r2[$i]*$v2y[$i]+$r3[$i]*$v3z[$i];
if($sum1[$i] > 0)
{
$angle[$i] = -$angle[$i];
}
}
my $top_ram= $subframe2_ram;
my $arrayVar = {};
my ($rows,$cols)=($nc,5);
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $tr=$top_ram->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, 
-height =>27,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$tr->rowHeight(0,1); 
$tr->colWidth(20,20,20,20,20,20); 
$tr->colWidth(1=>20,0=>15,2=>22,3=>22,4=>22);
$tr->activate("1,0");
$tr->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$tr->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$arrayVar->{"0,0"} = "Chain";
$arrayVar->{"0,1"} = "Residue Name";
$arrayVar->{"0,2"} = "Residue No.";
$arrayVar->{"0,3"} = "PHI angle";
$arrayVar->{"0,4"} = "PSI angle";
open(FH,$m);
@rnq=();@nxq=();@nyq=();@nzq=();@rcaq=();@caxq=();@cayq=();@cazq=();@rcq=();@cxq=();@cyq=();@czq=();
$ncq=0;
while(<FH>)
{
if($_=~/^ATOM/)
{
if(substr($_,21,1) eq $ram)
{
if(substr($_,13,3) eq 'N  ')
{
$ncq++;
push(@rnq,substr($_,23,3));
push(@nxq,substr($_,31,7));
push(@nyq,substr($_,39,7));
push(@nzq,substr($_,47,7));
}
if(substr($_,13,3) eq 'CA ')
{
push(@rcaq,substr($_,23,3));
push(@caxq,substr($_,31,7));
push(@cayq,substr($_,39,7));
push(@cazq,substr($_,47,7));
}
if(substr($_,13,3) eq 'C  ')
{
push(@rcq,substr($_,23,3));
push(@cxq,substr($_,31,7));
push(@cyq,substr($_,39,7));
push(@czq,substr($_,47,7));
}
}
}
}
@v1xq=();@v1yq=();@v1zq=();
@v2xq=();@v2yq=();@v2zq=();
@v3xq=();@v3yq=();@v3zq=();
for($i=1;$i<$ncq;$i++)
{
push(@v1xq,$caxq[$i-1]-$nxq[$i-1]);
push(@v1yq,$cayq[$i-1]-$nyq[$i-1]);
push(@v1zq,$cazq[$i-1]-$nzq[$i-1]);
push(@v2xq,$cxq[$i-1]-$caxq[$i-1]);
push(@v2yq,$cyq[$i-1]-$cayq[$i-1]);
push(@v2zq,$czq[$i-1]-$cazq[$i-1]);
push(@v3xq,$nxq[$i]-$cxq[$i-1]);
push(@v3yq,$nyq[$i]-$cyq[$i-1]);
push(@v3zq,$nzq[$i]-$czq[$i-1]);
}
@pyzq=();@pxzq=();@pxyq=();
@qyzq=();@qxzq=();@qxyq=();
for($i=0;$i<$ncq;$i++)
{
push(@pyzq,$v1yq[$i]*$v2zq[$i]-$v1zq[$i]*$v2yq[$i]);
push(@pxzq,$v1zq[$i]*$v2xq[$i]-$v1xq[$i]*$v2zq[$i]);
push(@pxyq,$v1xq[$i]*$v2yq[$i]-$v1yq[$i]*$v2xq[$i]);
push(@qyzq,$v2yq[$i]*$v3zq[$i]-$v2zq[$i]*$v3yq[$i]);
push(@qxzq,$v2zq[$i]*$v3xq[$i]-$v2xq[$i]*$v3zq[$i]);
push(@qxyq,$v2xq[$i]*$v3yq[$i]-$v2yq[$i]*$v3xq[$i]);
}
@r1q=();@r2q=();@r3q=();
for($i=0;$i<$ncq;$i++)
{
push(@r1q,$pzxq[$i]*$qxyq[$i]-$pxyq[$i]*$qzxq[$i]);
push(@r2q,$pxyq[$i]*$qyzq[$i]-$pyzq[$i]*$qxyq[$i]);
push(@r3q,$pyzq[$i]*$qzxq[$i]-$pzxq[$i]*$qyzq[$i]);
}

@lq=();@lpq=();@lqq=();@cosvalq=();@sinvalq=();@angleq=();
for($i=0;$i<$ncq-1;$i++)
{
$sumq[$i]=$pyzq[$i]*$qyzq[$i]+$pxzq[$i]*$qxzq[$i]+$pxyq[$i]*$qxyq[$i];
$lpq[$i]=sqrt($pyzq[$i]*$pyzq[$i]+$pxzq[$i]*$pxzq[$i]+$pxyq[$i]*$pxyq[$i]);
$lqq[$i]=sqrt($qyzq[$i]*$qyzq[$i]+$qxzq[$i]*$qxzq[$i]+$qxyq[$i]*$qxyq[$i]);
$lq[$i]=$lpq[$i]*$lqq[$i];
}
for($i=0;$i<$ncq-1;$i++)
{
$cosvalq[$i]+=$sumq[$i]/$lq[$i];
$sinsqvalq[$i]=1-($cosvalq[$i]*$cosvalq[$i]);
if($sinsqvalq[$i]<0)
{
$sinsqvalq[$i]=0;
}
$sinvalq[$i]=sqrt($sinsqvalq[$i]);
$angleq[$i]=-(atan2($sinvalq[$i],$cosvalq[$i])*57.29578);
}
@sum1q=();
for($i=0;$i<$ncq-1;$i++)
{
$sum1q[$i]=$r1q[$i]*$v2xq[$i]+$r2q[$i]*$v2yq[$i]+$r3q[$i]*$v3zq[$i];
if($sum1q[$i] > 0)
{
$angleq[$i] = -$angleq[$i];
}
}
$j=1;
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
#$angleq[$i]=round($angleq[$i],3);
%amino=('ALA'=>'A','ARG'=>'R','ASN'=>'N','ASP'=>'D','CYS'=>'C','GLU'=>'E','GLN'=>'Q','GLY'=>'G','HIS'=>'H',=>'ILE'=>'I','LEU'=>'L','LYS'=>'K','MET'=>'M',
'PHE'=>'F','PRO'=>'P','SER'=>'S','THR'=>'T','TRP'=>'W','TYR'=>'Y','VAL'=>'V');
for($i=1;$i<$ncq;$i++)
{
if(($angle[$i-1] >= '-180' && $angle[$i-1] <= $a) && ($angleq[$i] >= '-180' && $angleq[$i] <= $b))
{
$angleq[$i]=round($angleq[$i],3);
$angle[$i-1]=round($angle[$i-1],3);
$arrayVar->{"$j,4"} = "$angleq[$i]";
$arrayVar->{"$j,0"} = "$ram";
$arrayVar->{"$j,1"} = "$resname[$i]";
$arrayVar->{"$j,2"} = "$rn[$i]";
$arrayVar->{"$j,3"} = "$angle[$i-1]";
$j++;
$r->createText(343,343, -fill => 'black', -text =>"*"); 
if( ($angleq[$i] > 0) && ($angle[$i-1] > 0) )
{
$r->createText(320+(1.9*$angleq[$i]),320-(1.9*$angle[$i-1]), -fill => 'black', -text =>"$rn[$i]"); 

}
elsif( ($angleq[$i] > 0) && ($angle[$i-1] < 0) )
{
$angle[$i-1]=-$angle[$i-1];
$r->createText(320-(1.9*$angleq[$i]),320-(1.9*$angle[$i-1]), -fill => 'black', -text =>"$rn[$i]"); 
}
elsif( ($angleq[$i] < 0) && ($angle[$i-1] > 0) )
{
$angleq[$i]=-$angleq[$i];
$r->createText(320+(1.9*$angleq[$i]),320+(1.9*$angle[$i-1]), -fill => 'black', -text =>"$rn[$i]"); 
}
elsif( ($angleq[$i] < 0) && ($angle[$i-1] < 0) )
{
$angle[$i-1]=-$angle[$i-1];
$angleq[$i]=-$angleq[$i];
$r->createText(320-(1.9*$angleq[$i]),320+(1.9*$angle[$i-1]), -fill => 'black', -text =>"$rn[$i]"); 
}
}
}
}
##################################################
#####               PDB EDITOR               #####
#####    Edit your file to your desired way  #####
##################################################
sub editor
{
$mw = MainWindow->new(-title=>'PDB Editor');
$mw->geometry(($mw->maxsize())[0] .'x'.($mw->maxsize())[1]);
$mw->overrideredirect(1);
$mbar=$mw->Menu();
$mw->configure(-menu=>$mbar);
$f=$mbar->cascade(-label=>"File", -underline=>0, -tearoff => 0);
$s=$mbar->cascade(-label=>"Search",-underline=>0,-tearoff=>0);
$o=$mbar->cascade(-label =>"Deletion", -underline=>0, -tearoff => 0);
$m=$mbar->cascade(-label =>"Home", -underline=>0, -tearoff => 0);
$v=$mbar->cascade(-label =>"Insertion", -underline=>0, -tearoff => 0);
$r=$mbar->cascade(-label =>"Co-ordinate Replace", -underline=>0, -tearoff => 0);
$f->command(-label => "Open", -underline=>0, -command=>\&yipe);
$f->command(-label =>"Exit", -underline => 1,-command => sub { exit } );
$o->command(-label =>"Atom Number Deletion", -command=>\&rngedis);
$o->command(-label =>"Residue Number Deletion", -command=>\&residel);
$s->command(-label =>"Redisue Search",-command=>\&research);
$s->command(-label =>"Nitrogen Search",-command=>\&nsearch);
$s->command(-label =>"Calpha Search",-command=>\&casearch);
$s->command(-label =>"Carbon Search",-command=>\&csearch);
$s->command(-label =>"Oxygen Search",-command=>\&osearch);
$m->command(-label =>"Home Page",-command=>\&yipea);
$v->command(-label =>"Insertion",-command=>\&insertion);
$r->command(-label =>"C Alpha",-command=>\&car);
$r->command(-label =>"C Beeta",-command=>\&bar);
my $arrayVar = {};
sub yipe
{
$edd=$mw->getOpenFile();
if($edd ne "")
{
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$s="";
$pe="";
$ce="";
$s=$fm_set2ed->Radiobutton(-text=>"Atom",-value=>"ATOM  ",-variable=>\$pe,-command=>sub {$ce=$pe; sabae($ce)},-font=>[-size =>'10'])->pack(-side=>'left');
$s=$fm_set2ed->Radiobutton(-text=>"Hetra_Atom",-value=>"HETATM",-variable=>\$pe,-command=>sub {$ce=$pe; sabae($ce)},-font=>[-size =>'10'])->pack(-side=>'left');    
open(SI,$edd);
open(FF,">tool.pdb");
while(<SI>)
{
print FF $_;
}
close SI;
close FF;
open(SS,"tool.pdb");
@pdb=();
$i=0;
while(<SS>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j]
}
$i++;
}
close SS;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,13);
$rw ||= $rows;
$cw ||= $cols;

if($ce eq "ATOM  ")
{
@name=qw(Delete - Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
}
else
{
@name1=qw(Delete - Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name1[$j]";
}
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>15,1=>19,2=>19,3=>19,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
}
}
sub insertion
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set1ed->destroy();
$fm_set3ed->destroy();
$fm_set4ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$s="";
$pe="";
$ce="";
$s=$fm_set2ed->Radiobutton(-text=>"After",-value=>"a",-variable=>\$pe,-command=>sub {$ce=$pe; insertrow($ce)},-font=>[-size =>'10'])->pack(-side=>'left');
$s=$fm_set2ed->Radiobutton(-text=>"Before",-value=>"b",-variable=>\$pe,-command=>sub {$ce=$pe; insertrow($ce)},-font=>[-size =>'10'])->pack(-side=>'left');    
}
}
sub insertrow
{
$fm_set1ed->destroy();
$fm_set3ed->destroy();
$fm_set4ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
my($choice)=@_;
if($choice eq "a")
{
$l=$fm_set3ed->Label(-text=>"Enter the atom number after which the row must be inserted")->pack(-side=>"left");
$ee=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"Insert",-command=>\&intro)->pack(-side=>"left");
sub intro
{
$option=$ee->get();
open(SI,$edd);
open(FF,">tool.pdb");
while(<SI>)
{
if($_=~/^ATOM/)
{
print FF $_;
}
}
close SI;
close FF;
open(SS,"tool.pdb");
@pdb=();
$i=0;
while(<SS>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j]
}
$i++;
}
close SS;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
$count++;
$z=$option+1;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
$k=0;
for($i=1;$i<$rw;$i++)
{
if($z == $pdb[$i-1][1])
{
$arrayVar->{"$i,0"}="ATOM";
$arrayVar->{"$i,1"}=" ";
$arrayVar->{"$i,2"}=" ";
$arrayVar->{"$i,3"}=" ";
$arrayVar->{"$i,4"}=" ";
$arrayVar->{"$i,5"}=" ";
$arrayVar->{"$i,6"}=" ";
$arrayVar->{"$i,7"}=" ";
$arrayVar->{"$i,8"}=" ";
$arrayVar->{"$i,9"}=" ";
$arrayVar->{"$i,10"}=" ";
$arrayVar->{"$i,11"}=" ";
$arrayVar->{"$i,12"}=" ";
}
else
{
$k++;
$arrayVar->{"$i,0"}="$pdb[$i-1][0]";
$arrayVar->{"$i,1"}="$k";
$arrayVar->{"$i,2"}="$pdb[$i-1][2]";
$arrayVar->{"$i,3"}="$pdb[$i-1][3]";
$arrayVar->{"$i,4"}="$pdb[$i-1][4]";
$arrayVar->{"$i,5"}="$pdb[$i-1][5]";
$arrayVar->{"$i,6"}="$pdb[$i-1][6]";
$arrayVar->{"$i,7"}="$pdb[$i-1][7]";
$arrayVar->{"$i,8"}="$pdb[$i-1][8]";
$arrayVar->{"$i,9"}="$pdb[$i-1][9]";
$arrayVar->{"$i,10"}="$pdb[$i-1][10]";
$arrayVar->{"$i,11"}="$pdb[$i-1][11]";
$arrayVar->{"$i,12"}="$pdb[$i-1][12]";
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<=$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>15,1=>19,2=>19,3=>19,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
else
{
$l=$fm_set3ed->Label(-text=>"Enter the atom number before which the row must be inserted")->pack(-side=>"left");
$ee=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"Insert",-command=>\&into)->pack(-side=>"left");
sub into
{
$optq=$ee->get();
open(SI,$edd);
open(FF,">tool.pdb");
while(<SI>)
{
if($_=~/^ATOM/)
{
print FF $_;
}
}
close SI;
close FF;
open(SS,"tool.pdb");
@pdb=();
$i=0;
while(<SS>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j]
}
$i++;
}
close SS;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
$count++;
$z=$optq;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
$k=0;
for($i=1;$i<$rw;$i++)
{
if($z == $pdb[$i-1][1])
{
$arrayVar->{"$i,0"}="ATOM";
$arrayVar->{"$i,1"}=" ";
$arrayVar->{"$i,2"}=" ";
$arrayVar->{"$i,3"}=" ";
$arrayVar->{"$i,4"}=" ";
$arrayVar->{"$i,5"}=" ";
$arrayVar->{"$i,6"}=" ";
$arrayVar->{"$i,7"}=" ";
$arrayVar->{"$i,8"}=" ";
$arrayVar->{"$i,9"}=" ";
$arrayVar->{"$i,10"}=" ";
$arrayVar->{"$i,11"}=" ";
$arrayVar->{"$i,12"}=" ";
}
else
{
$k++;
$arrayVar->{"$i,0"}="$pdb[$i-1][0]";
$arrayVar->{"$i,1"}="$k";
$arrayVar->{"$i,2"}="$pdb[$i-1][2]";
$arrayVar->{"$i,3"}="$pdb[$i-1][3]";
$arrayVar->{"$i,4"}="$pdb[$i-1][4]";
$arrayVar->{"$i,5"}="$pdb[$i-1][5]";
$arrayVar->{"$i,6"}="$pdb[$i-1][6]";
$arrayVar->{"$i,7"}="$pdb[$i-1][7]";
$arrayVar->{"$i,8"}="$pdb[$i-1][8]";
$arrayVar->{"$i,9"}="$pdb[$i-1][9]";
$arrayVar->{"$i,10"}="$pdb[$i-1][10]";
$arrayVar->{"$i,11"}="$pdb[$i-1][11]";
$arrayVar->{"$i,12"}="$pdb[$i-1][12]";
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<=$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>15,1=>19,2=>19,3=>19,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
sub saveinserted
{
my $filename5=$mw->getSaveFile(-title =>'Save File:',
-defaultextension => '*.*', -initialdir => '.' );
open(EDITOR,">$filename5");
my ($rows,$cols) = ($count, 13 );
$rw ||= $rows;
$cw||= $cols;
for($i=1;$i<$count;$i++)
{
print EDITOR $arrayVar->{"$i,0"};
if(length($i) == 1)
{
print EDITOR "      ";
}
elsif(length($i) == 2)
{
print EDITOR "     ";
}
elsif(length($i) == 3)
{
print EDITOR "    ";
}
elsif(length($i) == 4)
{
print EDITOR "   ";
}
print EDITOR $i,"  ";
print EDITOR $arrayVar->{"$i,2"};
$z=$arrayVar->{"$i,2"};
if(length($z) == 1)
{
print EDITOR "   ";
}
elsif(length($z) == 2)
{
print EDITOR "  ";
}
elsif(length($z) == 3)
{
print EDITOR " ";
}
print EDITOR $arrayVar->{"$i,3"}," ";
print EDITOR $arrayVar->{"$i,4"};
$j=$arrayVar->{"$i,5"};
if(length($j) == 1)
{
print EDITOR "   ";
}
elsif(length($j) == 2)
{
print EDITOR "  ";
}
elsif(length($j) == 3)
{
print EDITOR " ";
}
print EDITOR $arrayVar->{"$i,5"},"     ";
$r=$arrayVar->{"$i,6"};
if(length($r) == 7)
{
print EDITOR "     ";
}
elsif(length($r) == 6)
{
print EDITOR "      ";
}
elsif(length($r) == 5)
{
print EDITOR "       ";
}
print EDITOR $arrayVar->{"$i,6"};
$d=$arrayVar->{"$i,7"};
if(length($d) == 7)
{
print EDITOR " ";
}
elsif(length($d) == 6)
{
print EDITOR "  ";
}
elsif(length($d) == 5)
{
print EDITOR "   ";
}
print EDITOR $arrayVar->{"$i,7"};
$q=$arrayVar->{"$i,8"};
if(length($q) == 7)
{
print EDITOR " ";
}
elsif(length($q) == 6)
{
print EDITOR "  ";
}
elsif(length($q) == 5)
{
print EDITOR "   ";
}
print EDITOR $arrayVar->{"$i,8"},"  ";
print EDITOR $arrayVar->{"$i,9"};
$f=$arrayVar->{"$i,9"};
if(length($f) == 4)
{
print EDITOR "  ";
}
elsif(length($f) == 5)
{
print EDITOR " ";
}
print EDITOR $arrayVar->{"$i,10"},"           ";
print EDITOR $arrayVar->{"$i,11"};
print EDITOR "\n";
}
}
}
sub yipea
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set1ed->destroy();
$fm_set3ed->destroy();
$fm_set4ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$s="";
$pe="";
$ce="";
$s=$fm_set2ed->Radiobutton(-text=>"Atom",-value=>"ATOM  ",-variable=>\$pe,-command=>sub {$ce=$pe; sabae($ce)},-font=>[-size =>'10'])->pack(-side=>'left');
$s=$fm_set2ed->Radiobutton(-text=>"Hetra_Atom",-value=>"HETATM",-variable=>\$pe,-command=>sub {$ce=$pe; sabae($ce)},-font=>[-size =>'10'])->pack(-side=>'left');    
open(SI,$edd);
open(FF,">tool.pdb");
while(<SI>)
{
print FF $_;
}
close SI;
close FF;
open(SS,"tool.pdb");
@pdb=();
$i=0;
while(<SS>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j]
}
$i++;
}
close SS;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,13);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=" ";
}
}
if($ce eq "ATOM  ")
{
@name=qw(Delete - Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
}
else
{
@name1=qw(Delete - Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name1[$j]";
}
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-height=>$count,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>15,1=>19,2=>19,3=>19,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$t->pack(-expand => 1, -fill => 'both');
}
}
sub sabae
{
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
my($d)=@_;
open(SI1,$edd);
open(FF1,">tool.pdb");
while(<SI1>)
{
if(substr($_,0,6) eq $d)
{
print FF1 $_;
}
}
close SI1;
close FF1;
open(SS1,"tool.pdb");
@pdb=();
$i=0;
while(<SS1>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j]
}
$i++;
}
close SS;
$tilt=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$tilt++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$tilt++;
my ($rows,$cols) = ($tilt,13);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=1;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}="$pdb[$i-1][$j-1]";
}
}
if($ce eq "ATOM  ")
{
@name=qw(Delete ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
}
else
{
@name1=qw(Delete HETATM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name1[$j]";
}
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
@qq=();
for($i=1;$i<$rw;$i++)
{
$l[$i]=$mw->Radiobutton(-text => '           ',-value=>"$i",-variable=>\$rr,-command=>sub {$q=$rr; push(@qq,$q); clear(@qq)});
}
for($w=1;$w<$rw;$w++)
{
$t->windowConfigure( "$w,0", -sticky => 's', -window => $l[$w] );
}
}
Tk::MainLoop;
sub clear
{
my(@zz)=@_;
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x');
my ($rows,$cols) = ($tilt,13);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($k=0;$k<scalar(@zz);$k++)
{
if($i == $zz[$k])
{
for($j=1;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}="  ";
$pdb[$i-1][$j-1]=" ";
}
}
else
{
for($j=1;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}="$pdb[$i-1][$j-1]";
}
}
}
}
if($ce eq "ATOM  ")
{
@name=qw(Delete ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
}
else
{
@name1=qw(Delete HETATM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name1[$j]";
}
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$but=$fm_set1ed->Button(-text=>"Save",-command=>\&saveed)->pack();
for($i=1;$i<$rw;$i++)
{
$l[$i]=$mw->Radiobutton(-text => '           ',-value=>"$i",-variable=>\$rr,-command=>sub {$q=$rr; push(@qq,$q); clear(@qq)});
}
for($w=1;$w<$rw;$w++)
{
$t->windowConfigure( "$w,0", -sticky => 's', -window => $l[$w] );
}
}
sub brscmd 
{
my ($previous_index, $actual_index) = @_;
my ($row, $col) = split ',', $actual_index;
my ($sel, $js);
my $sel =  $t->curselection();
foreach $js (@$sel) 
{
print $arrayVar->{"$row,$col"};
}
}
sub saveed
{
my $filename5=$mw->getSaveFile(-title =>'Save File:',
-defaultextension => '*.*', -initialdir => '.' );
open(EDITOR,">$filename5");
my ($rows,$cols) = ($tilt, 13 );
$rw ||= $rows;
$cw||= $cols;
$z=1;
for($i=1;$i<$tilt;$i++)
{
$w1=$arrayVar->{"$i,1"};
if($w1 eq "  ")
{
next;
}
else
{
$a=$z;
if(length($a) == 1)
{
print EDITOR $arrayVar->{"$i,1"},"      ";
}
elsif(length($a) == 2)
{
print EDITOR $arrayVar->{"$i,1"},"     ";
}
elsif(length($a) == 3)
{
print EDITOR $arrayVar->{"$i,1"},"    ";
}
elsif(length($a) == 4)
{
print EDITOR $arrayVar->{"$i,1"},"   ";
}
print EDITOR $z,"  ";
$b=$arrayVar->{"$i,3"};
if(length($b) == 1)
{
print EDITOR $arrayVar->{"$i,3"},"   ";
}
elsif(length($b) == 2)
{
print EDITOR $arrayVar->{"$i,3"},"  ";
}
elsif(length($b) == 3)
{
print EDITOR $arrayVar->{"$i,3"}," ";
}
print EDITOR $arrayVar->{"$i,4"}," ";
$c=$arrayVar->{"$i,6"};
if(length($c) == 1)
{
print EDITOR $arrayVar->{"$i,5"},"   ";
}
if(length($c) == 2)
{
print EDITOR $arrayVar->{"$i,5"},"  ";
}
if(length($c) == 3)
{
print EDITOR $arrayVar->{"$i,5"}," ";
}
print EDITOR $arrayVar->{"$i,6"},"      ";
print EDITOR $arrayVar->{"$i,7"}," ";
print EDITOR $arrayVar->{"$i,8"}," ";
print EDITOR $arrayVar->{"$i,9"},"  ";
print EDITOR $arrayVar->{"$i,10"}," ";
print EDITOR $arrayVar->{"$i,11"},"           ";
print EDITOR $arrayVar->{"$i,12"};
print EDITOR "\n";
$z++;
}
}
}
sub research
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$l=$fm_set3ed->Label(-text=>"Enter the Residue to be searched")->pack(-side=>"left");
$e=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"search",-command=>\&search)->pack(-side=>"left");
$b1=$fm_set3ed->Button(-text=>"original file",-command=>\&ori)->pack(-side=>"left");
}
}
sub car
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$l=$fm_set3ed->Label(-text=>"Enter the Residue whose Ca you want to replace")->pack(-side=>"left");
$e=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"search",-command=>\&carss)->pack(-side=>"left");
$br=$fm_set3ed->Button(-text=>"replace",-command=>\&replace);
$zc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$lz=$fm_set3ed->Label(-text=>"Z cor");
$yc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$ly=$fm_set3ed->Label(-text=>"Y cor");
$xc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$lx=$fm_set3ed->Label(-text=>"X cor");
}
}
sub bar
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$l=$fm_set3ed->Label(-text=>"Enter the Residue whose Ca you want to replace")->pack(-side=>"left");
$e=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"search",-command=>\&barss)->pack(-side=>"left");
$br=$fm_set3ed->Button(-text=>"replace",-command=>\&replace);
$zc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$lz=$fm_set3ed->Label(-text=>"Z cor");
$yc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$ly=$fm_set3ed->Label(-text=>"Y cor");
$xc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10']);
$lx=$fm_set3ed->Label(-text=>"X cor");
}
}
sub carss
{
$find=$e->get();
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$br->destroy();
$zc->destroy();
$lz->destroy();
$yc->destroy();
$ly->destroy();
$xc->destroy();
$lx->destroy();
$br=$fm_set3ed->Button(-text=>"replace",-command=>\&replace)->pack(-side=>"right");
$zc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$lz=$fm_set3ed->Label(-text=>"Z cor")->pack(-side=>"right");
$yc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$ly=$fm_set3ed->Label(-text=>"Y cor")->pack(-side=>"right");
$xc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$lx=$fm_set3ed->Label(-text=>"X cor")->pack(-side=>"right");
open(SI2,$edd);
open(FF2,">tool.pdb");
while(<SI2>)
{
print FF2 $_;
}
close FF2;
close SI2;
open(SS2,"tool.pdb");
@pdb=();
$i=0;
while(<SS2>)
{
if($_=~/^ATOM/)
{
if(substr($_,17,3) eq $find)
{
if(substr($_,13,4) eq "CA  ")
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
}
}
}
close SS2;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq ||= $rows;
$cq ||= $cols;
for($i=1;$i<$rq;$i++)
{
for($j=0;$j<$cq;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cq;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
}
sub barss
{
$find=$e->get();
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$br->destroy();
$zc->destroy();
$lz->destroy();
$yc->destroy();
$ly->destroy();
$xc->destroy();
$lx->destroy();
$br=$fm_set3ed->Button(-text=>"replace",-command=>\&replace)->pack(-side=>"right");
$zc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$lz=$fm_set3ed->Label(-text=>"Z cor")->pack(-side=>"right");
$yc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$ly=$fm_set3ed->Label(-text=>"Y cor")->pack(-side=>"right");
$xc=$fm_set3ed->Entry(-width=>20,-font=>[-size =>'10'])->pack(-side=>"right");
$lx=$fm_set3ed->Label(-text=>"X cor")->pack(-side=>"right");
open(SI2,$edd);
open(FF2,">tool.pdb");
while(<SI2>)
{
print FF2 $_;
}
close FF2;
close SI2;
open(SS2,"tool.pdb");
@pdb=();
$i=0;
while(<SS2>)
{
if($_=~/^ATOM/)
{
if(substr($_,17,3) eq $find)
{
if(substr($_,13,4) eq "CB  ")
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
}
}
}
close SS2;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq ||= $rows;
$cq ||= $cols;
for($i=1;$i<$rq;$i++)
{
for($j=0;$j<$cq;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cq;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
}
sub replace
{
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$xcr=$xc->get();
$ycr=$yc->get();
$zcr=$zc->get();
open(REP,"tool.pdb");
open(REP1,">rep.pdb");
$pdbcount=0;
while(<REP>)
{
if($_=~/^ATOM/)
{
if(substr($_,17,3) eq $find)
{
if(substr($_,13,4) eq "CA  ")
{
$subx=substr($_,31,7);
$suby=substr($_,39,7);
$subz=substr($_,47,7);
cal($xcr,$ycr,$zcr,$subx,$suby,$subz);
}
else
{
print REP1 $_;
}
}
else
{
print REP1 $_;
}
}
else
{
print REP1 $_;
}
}
close REP;
close REP1;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq ||= $rows;
$cq ||= $cols;
for($i=1;$i<$rq;$i++)
{
for($j=0;$j<$cq;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cq;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Label(-text=>"Your file has been saved as 'rep.pdb'",-font=>[-size =>'10'])->pack();
}
sub cal
{
my($xcr,$ycr,$zcr,$subx,$suby,$subz)=@_;
if($xcr ne "")
{
$_=~s/$subx/$xcr/;
}
if($ycr ne "")
{
$_=~s/$suby/$ycr/;
}

if($zcr ne "")
{
$_=~s/$subz/$zcr/;
}
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$pdbcount][$j]=$sai[$j];
}
$pdbcount++;
print REP1 $_;
}
sub search
{
$find=$e->get();
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
open(SI2,$edd);
open(FF2,">tool.pdb");
while(<SI2>)
{
if($_=~/^ATOM/)
{
if(substr($_,17,3) eq $find)
{
print FF2 $_;
}
}
}
close FF2;
close SI2;
open(SS2,"tool.pdb");
@pdb=();
$i=0;
while(<SS2>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS2;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq ||= $rows;
$cq ||= $cols;
for($i=1;$i<$rq;$i++)
{
for($j=0;$j<$cq;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cq;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
sub ori
{
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$l=$fm_set3ed->Label(-text=>"Enter the Residue to be searched")->pack(-side=>"left");
$e=$fm_set3ed->Entry(-width=>20)->pack(-side=>"left");
$b=$fm_set3ed->Button(-text=>"search",-command=>\&search)->pack(-side=>"left");
$b1=$fm_set3ed->Button(-text=>"original file",-command=>\&ori)->pack(-side=>"left");
open(SI3,$edd);
open(FF3,">tool.pdb");
while(<SI3>)
{
if($_=~/^ATOM/)
{
print FF3 $_;
}
}
close FF3;
close SI3;
open(SS3,"tool.pdb");
@pdb=();
$i=0;
while(<SS3>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS3;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}=$name[$j];
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
sub rngedis
{
if($edd ne "")
{
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
my $dropdown_value;
my $dropdown = $fm_set2ed->BrowseEntry(-label => "                                      				                                     From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(DELE,$edd);
@finishs=();
@begins=();
while(<DELE>)
{
if($_=~/^ATOM/)
{
$start=substr($_,7,4);
push(@begins,$start);
$end=substr($_,7,4);
push(@finishs,$end);
}
}
close DELE;
foreach (@begins) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_set2ed->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach ( @finishs) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_set2ed->Button(-text=>"Delete",-command=>sub{$fs=$dropdown_value; 
$es=$dropdown_valueq;
letsgo($fs,$es)})->pack(-anchor=>'nw',-side=>'left');
}
}
sub residel
{
if($edd ne "")
{
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
my $dropdown_value;
my $dropdown = $fm_set2ed->BrowseEntry(-label => "                                      				                                     From",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
open(DELEQ,$edd);
@fainishs=();
@baegins=();
while(<DELEQ>)
{
if($_=~/^ATOM/)
{
$start=substr($_,23,3);
push(@baegins,$start);
$end=substr($_,23,3);
push(@fainishs,$end);
}
}
close DELEQ;
@fbegins=();
@ffinishs=();
for($i=0;$i<scalar(@baegins);$i++)
{
for($j=$i+1;$j<scalar(@baegins);$j++)
{
if($baegins[$i] eq $baegins[$j])
{
next;
}
else
{
push(@fbegins,$baegins[$i]);
push(@ffinishs,$fainishs[$i]);
$i=$j;
last;
}
}
}
foreach (@fbegins) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_set2ed->BrowseEntry(-label => "To",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach ( @ffinishs) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_set2ed->Button(-text=>"Delete",-command=>sub{$fs=$dropdown_value; 
$es=$dropdown_valueq;
resiresi($fs,$es)})->pack(-anchor=>'nw',-side=>'left');
}
}
sub letsgo
{
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x');
my($from,$to)=@_;
open(SI5,$edd);
open(FF5,">tool.pdb");
while(<SI5>)
{
if($_=~/^ATOM/)
{
print FF5 $_;
}
}
close FF5;
close SI5;
open(SS5,"tool.pdb");
@pdb=();
$i=0;
while(<SS5>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS5;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq1 ||= $rows;
$cq1 ||= $cols;
for($i=0;$i<$rq1;$i++)
{
for($j=0;$j<$cq1;$j++) 
{
if(($pdb[$i][1] >= $from) && ($pdb[$i][1] <= $to))
{
$k=$i+1;
$arrayVar->{"$k,$j"}="  ";
}
else
{
$k=$i+1;
$arrayVar->{"$k,$j"}=$pdb[$i][$j];
}
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw1;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
sub resiresi
{
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
my($from,$to)=@_;
open(SI6,$edd);
open(FF6,">tool.pdb");
while(<SI6>)
{
if($_=~/^ATOM/)
{
print FF6 $_;
}
}
close FF6;
close SI6;
open(SS6,"tool.pdb");
@pdb=();
$i=0;
while(<SS6>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS6;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rq ||= $rows;
$cq ||= $cols;
for($i=0;$i<$rq;$i++)
{
for($j=0;$j<$cq;$j++) 
{
if(($pdb[$i][5] >= $from) && ($pdb[$i][5] <= $to))
{
$k=$i+1;
$arrayVar->{"$k,$j"}="  ";
}
else
{
$k=$i+1;
$arrayVar->{"$k,$j"}=$pdb[$i][$j];
}
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
sub nsearch
{
if($edd ne "")
{
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
open(SI7,$edd);
open(FF7,">tool.pdb");
while(<SI7>)
{
if($_=~/^ATOM/)
{
if(substr($_,77,1) eq 'N')
{
print FF7 $_;
}
}
}
close SI7;
close FF7;
open(SS7,"tool.pdb");
@pdb=();
$i=0;
while(<SS7>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS7;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
sub casearch
{
if($edd ne "")
{
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
open(SI7,$edd);
open(FF7,">tool.pdb");
while(<SI7>)
{
if($_=~/^ATOM/)
{
if(substr($_,13,4) eq 'CA  ')
{
print FF7 $_;
}
}
}
close SI7;
close FF7;
open(SS7,"tool.pdb");
@pdb=();
$i=0;
while(<SS7>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS7;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
sub csearch
{
if($edd ne "")
{
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
open(SI8,$edd);
open(FF8,">tool.pdb");
while(<SI8>)
{
if($_=~/^ATOM/)
{
if(substr($_,77,1) eq 'C')
{
print FF8 $_;
}
}
}
close SI8;
close FF8;
open(SS8,"tool.pdb");
@pdb=();
$i=0;
while(<SS8>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS8;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"n";
}
"n";
}
$count++;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
sub osearch
{
if($edd ne "")
{
$fm_set3ed->destroy();
$fm_set3ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set3ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set1ed);
$fm_set4ed->destroy();
$fm_set4ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set4ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set3ed);
$fm_set2ed->destroy();
$fm_set2ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set2ed->pack(-side=>'top',-expand=>0,-fill=>'x');
$fm_set1ed->destroy();
$fm_set1ed = $mw->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set1ed->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set2ed);
open(SI9,$edd);
open(FF9,">tool.pdb");
while(<SI9>)
{
if($_=~/^ATOM/)
{
if(substr($_,77,1) eq 'O')
{
print FF9 $_;
}
}
}
close SI9;
close FF9;
open(SS9,"tool.pdb");
@pdb=();
$i=0;
while(<SS9>)
{
@sai=();
@sai=split(/\s+/,$_);
for($j=0;$j<scalar(@sai);$j++)
{
$pdb[$i][$j]=$sai[$j];
}
$i++;
}
close SS9;
$count=0;
for($i=0;$i<scalar(@pdb);$i++)
{
$count++;
for($j=0;$j<scalar(@pdb);$j++)
{
"";
}
"";
}
$count++;
my ($rows,$cols) = ($count,12);
$rw ||= $rows;
$cw ||= $cols;
for($i=1;$i<$rw;$i++)
{
for($j=0;$j<$cw;$j++) 
{
$arrayVar->{"$i,$j"}=$pdb[$i-1][$j];
}
}
@name=qw(ATOM Atm_no. Atom_Name Residue Chain Residue_No. X_co-ordinate Y_co-ordinate Z_co-ordinate Occupancy_factor Temprature_factor Element_Symbol);
for($j=0;$j<$cw;$j++)
{
$arrayVar->{"0,$j"}="$name[$j]";
}
$t = $fm_set1ed->Scrolled('TableMatrix', -rows => $rows, -cols => $cols,-width => 10,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,
-coltagcommand => \&colSub,-browsecommand => \&brscmd,-colstretchmode => 'last',-rowstretchmode => 'last',
-selectmode => 'extended',-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-bg => 'white',-cache => 1);
$t->colWidth(0=>10,1=>15,2=>19,3=>15,4=>19,5=>15,6=>19,7=>19,8=>19,9=>19,10=>19,11=>15);
$t->pack(-expand => 1, -fill => 'both');
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
sub colSub{
  my $col = shift;
  return "OddCol" if( $col > 0 && $col%2) ;
}
$buter=$fm_set1ed->Button(-text=>"Save",-command=>\&saveinserted)->pack();
}
}
}
##################################################
#####          Entire download Section       #####
##################################################
sub download
{
my $filename1=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(CHAI,">$filename.pdb");
print CHAI $fire;
close CHAI;
}
sub downloads
{
my $filename2=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(SHEE,">$filename2.pdb");
print SHEE $op1;
close SHEE;
}
sub downloadh
{
my $filename3=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(HELIX,">$filename3.pdb");
print HELIX $oph;
close HELIX;
}
sub downloadhe
{
my $filename4=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(HETATM,">$filename4.pdb");
print HETATM $op13;
close HETATM;
}
sub cadownload
{
my $filename10=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(CADOWN,">$filename10");
print CADOWN $ss1;
close CADOWN;
}
sub resdownload
{
my $filename11=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(RESDOWN,">$filename11");
print RESDOWN $d;
close RESDOWN;
}
sub selectdownload
{
my $filename20=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(RESDOWNSE,">$filename20");
print RESDOWNSE $d;
close RESDOWNSE;
}
sub downloadnres
{
my $filename12=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(NRESDOWN,">$filename12");
print NRESDOWN $d;
close NRESDOWN;
}
sub bdownload
{
my $filename13=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(BDOWN,">$filename13");
print BDOWN $ss2;
close BDOWN;
}
sub sdownload
{
my $filename14=$fm_set->getSaveFile(-title =>'Save File:',-defaultextension => '*.*', -initialdir => '.' );
open(SDOWN,">$filename14");
print SDOWN $pos;
close SDOWN;
}
##################################################
#####          FILE CONVERTER SECTION        #####
#####     Convert your desired pdb file      #####
#####            to many formats             #####
##################################################
##################################################
#####    FAST PDB to download batch files    #####
##################################################
sub fpdb
{
$fm_set->destroy();
$fm_set = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_set->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_look);
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_look->destroy();
$fm_look = $mw_ppp->Frame(-relief=>'flat',-borderwidth=>5);
$fm_look->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_dirs);
$lala=$fm_set->Label(-text=>"Upload you text file containing all the PDB files displayed one below the other        ",-font=>[-size =>'10'])->pack(-side=>"left");
$baba=$fm_set->Button(-text=>"Upload text file",-command=>\&uploadtxt)->pack(-side=>"left");
}
sub uploadtxt
{
$textfile=$mw_ppp->getOpenFile();
$fp="";
$fp.="The PDB files you have downloaded:  (Click aa PDB file to view it)\n\n";
if($textfile ne "")
{
open(OP,$textfile);
@files=();
while(<OP>)
{
chomp($_);
push(@files,$_);
}
for($i=0;$i<scalar(@files);$i++)
{
$c=$i+1;
$fp.="$c. $files[$i]\n\n";
open(FF,">$files[$i].pdb");
my $mechanize = WWW::Mechanize->new(autocheck => 1);
$url = "http://www.rcsb.org/pdb/files/$files[$i].pdb";
$mechanize->get($url);
$c=$mechanize->content();
print FF $c;
close FF;
}
$txt->insert('1.0',"$fp");
$lala=$fm_set->Label(-text=>"    ",-font=>[-size =>'10'])->pack(-side=>"right");
$baba=$fm_set->Button(-text=>"Click to display",-command=>\&ctd)->pack(-side=>"right");
$lala=$fm_set->Label(-text=>"    ",-font=>[-size =>'10'])->pack(-side=>"right");
$fg=$fm_set->Entry(-width=>20)->pack(-side=>"right");
$lala=$fm_set->Label(-text=>"Enter the PDB file you want to view       ",-font=>[-size =>'10'])->pack(-side=>"right");
}
else
{
$txt->delete('1.0','end');
$txt1->delete('1.0','end');
$txt->insert('1.0',"* You have not selected any Text file. Please select a Text file *");
}
}
sub ctd
{
$i=$fg->get();
$s="";
open(FF,"$files[$i-1].pdb");
while(<FF>)
{
$s.=$_;
}
$txt1->delete('1.0','end');
$txt1->insert('1.0',"$s");
}
sub psa
{
$l1->destroy();
$l2->destroy();
$l3->destroy();
$l4->destroy();
$l5->destroy();
$l1=$fm_set->Label(-text=>"    ",-font=>[-size =>'10'])->pack(-side=>"right");
$l2=$fm_set->Button(-text=>"Calculate",-command=>\&psa1)->pack(-side=>"right");
$l3=$fm_set->Label(-text=>"    ",-font=>[-size =>'10'])->pack(-side=>"right");
$l4=$fm_set->Entry(-width=>20)->pack(-side=>"right");
$l5=$fm_set->Label(-text=>"Please enter your grid distance(default value=0.5)      ",-font=>[-size =>'10'])->pack(-side=>"right");
}
sub psa1
{
$grid_dist=$l4->get();
$diss="";
chomp($m);
$file_name=$m;
open FILE,"$file_name" or die "Can not open pdb file";
my @pdb=<FILE>;
if (($grid_dist eq 'D')|| ($grid_dist eq 'd') || ($grid_dist eq '') || ($grid_dist eq ''))
{
$grid_dist=0.5;
}
$diss.="\nYour protein sequence along with your surface sequence is as follows\n";
my %surface_pts;
my %cod = ("ALA"=>"A",
        "ARG"=>"R",
        "ASN"=>"N",
        "ASP"=>"D",
        "CYS"=>"C",
        "GLN"=>"Q",
        "GLU"=>"E",
        "GLY"=>"G",
        "HIS"=>"H",
        "ILE"=>"I",
        "LEU"=>"L",
        "LYS"=>"K",
        "MET"=>"M",
        "PHE"=>"F",
        "PRO"=>"P",
        "SER"=>"S",
        "TER"=>"X",
        "THR"=>"T",
        "TRP"=>"W",
        "TYR"=>"Y",
        "VAL"=>"V");
$file_name =~ m/(.*)\.pdb/;
my $genpdbid=$1;
my @inp;
my $lno=0;
for(my $line=0;$line<=scalar @pdb;$line++)
{
        if ($pdb[$line]=~ m/^ATOM.*(\w{3})\s(\w)\s*(\d{1,4})\s{4,7}(-?\d+\.\d+)\s*(-?\d+\.\d+)\s*(-?\d+\.\d+)/) {
                $inp[$lno]="$4  $5  $6  $1  $2  $3";
                $lno++;
        }
}
sort_and_findarms (@inp);
sort_and_findarms (@inp);
sort_and_findarms (@inp);
surface (0,'x','y',@inp);
surface (0,'x','z',@inp);
surface (1,'y','x',@inp);
surface (1,'y','z',@inp);
surface (2,'z','x',@inp);
surface (2,'z','y',@inp);
my $input_file="$file_name";
my $output_file="$input_file";
$output_file=~s/\.pdb/_sp.pdb/g;
open FILE,">"."$output_file";
my $time = localtime;
my @cur_date=split (/\s+/,$time);
print FILE "HEADER    TRANSFERASE               $cur_date[2]"."-"."$cur_date[1]"."-10   $genpdbid\n";
my $count_out=1;
foreach my $b(keys %surface_pts) {
        my @point = split (/\s+/, $b);
        my $xyz = "                               ";
        my $rn = $point[2];
        my $x = $point[3];
        my $y = $point[4];
        my $z = $point[5];
        my $rn1 = length($rn);
        my $x1 = length($x);
        my $y1 = length($y);
        my $z1 = length($z);
        my $rn2 = 3-$rn1;
        my $x2 = 15-$x1;
        my $y2 = 23-$y1;
        my $z2 = 31-$z1;
        substr ($xyz,$rn2,$rn1,$rn);
        substr ($xyz,$x2,$x1,$x);
        substr ($xyz,$y2,$y1,$y);
        substr ($xyz,$z2,$z1,$z);
        print FILE "ATOM      1  N   $point[0] $point[1] $xyz  1.00  0.00           N\n";
}
print  FILE "TER    4156      THR A 535\n";
close FILE;
my $inp ='';
my $out ='';
my @file = ("$input_file", "$output_file");
$output_file=~m/(.*)_sp\.pdb/;
my $path="$1"."_seq.fasta";
  my $file_co=1;
  my @mdm;
  my $ty=0;
  for my $file (@file) {
      $file =~ m/((.*)\/)?(.*)\.pdb/;
      my $pdbid = $3;
      my $structio = Bio::Structure::IO->new(-file => $file);
      my $struc = $structio->next_structure;
      my (%rn,@protein,%chain);
      my $resd=0;
      my $cha=1;
      for my $chain ($struc->get_chains) {
         my $chainid = $chain->id;
         for my $res ($struc->get_residues($chain)) {
            my $resid = $res->id;
            my $atoms = $struc->get_atoms($res);
            $protein[$resd]=$resid;
            $protein[$cha]=$chainid;
            $chain{$chainid} = 2;
            $resd+=2;
            $cha+=2;
         }
      }
     
    for my $ch(sort keys %chain) {
       my %hash=0;
       delete ($hash{0});
       for (my $gd=0;$gd<scalar (@protein);$gd++) {
            my $tk=$gd;
            if ($gd%2==0) {
                if ($ch eq $protein[($tk+1)]) {
                    my $foo=[split (/-/,$protein[$gd])];
                    if (exists $cod{$foo->[0]}) {
                       $hash{$foo->[1]}=$foo->[0];
                    }
                }    
            }
        }
        my $run =0;
        if ($file_co==1) {
            $inp.=">$pdbid:$ch\n";
            $ini_val= min keys %hash;
            $fin_val= max keys %hash;
            $mdm[$ty]="$ch\t$ini_val\t$fin_val";
            $ty++;
            for (my $i=$ini_val;$i<=$fin_val;$i++) {
                if ($run>59) {
                    $inp.="\n";
                    $run=0;
                }
                if (exists $hash{$i}) {
                    $inp.="$cod{$hash{$i}}";
                }
                else {
                    $inp.="-";
                }
                    $run++;
            }
               $inp.="\n";
        }
        elsif ($file_co==2) {
            $out.=">$pdbid:$ch\n";
            foreach my $line (@mdm) {
                my @id_m2m= split (/\t/,$line);
                if ($ch eq $id_m2m[0]) {
                    $ini_val= $id_m2m[1];
                    $fin_val= $id_m2m[2];   
                }
            }
            for (my $i=$ini_val;$i<=$fin_val;$i++) {
                if ($run>59) {
                    $out.= "\n";
                    $run=0;
                }
                if (exists $hash{$i}) {
                    $out.= "Y";
                }
                else {
                    $out.= "N";
                }
                    $run++;
            }
            $out.="\n";
        }
     }
    $file_co++;
  }
my $bar=[split /\n/,$inp];
my $pin= [split /\n/,$out];

for (my $k=0;($k<@$bar||$k<@$pin);$k++) {
        if ($pin->[$k]=~/>.*_sp:/) {
            
            #print "$bar->[$k]\n";
        }
        else {
            my $part=[split //,$bar->[$k]];
            my $part2=[split //,$pin->[$k]];
            my $c1='';
            my $c2='';
            for (my $j=0;($j<@$part||$j<@$part2);$j++) {
                if ($part->[$j]eq '-') {
                    $c1.=$part->[$j];
                    $c2.='X';
                }
                else {
                    $c1.=$part->[$j];
                    $c2.=$part2->[$j];
                }
            }
            $diss.= "$c1\n";        
            $diss.= "$c2\n\n";        
        }
}
my $x = '';
my $y = '';
my $z = '';

for(my $i=0;$i<scalar @pdb;$i++)
{
        if ($pdb[$i]=~ m/^ATOM.*(\w{3})\s(\w)\s{1,3}(\d{1,3})\s{4,7}(-?\d+\.\d+)\s*(-?\d+\.\d+)\s*(-?\d+\.\d+)/) {
                $x .= "$4\n";
                $y .= "$5\n";
                $z .= "$6\n";
        }
}
close FILE;

        my @xco = split (/\n/,$x);
        my @yco = split (/\n/,$y);
        my @zco = split (/\n/,$z);
        my $xmin =  min (@xco);
        my $xmax =  max (@xco);
        my $ymin =  min (@yco);
        my $ymax =  max (@yco);
        my $zmin =  min (@zco);
        my $zmax =  max (@zco);
open FILE, ">co.txt";
for (my $x1=$xmin;$x1<=$xmax;$x1+=2) {
        for (my $y1=$ymin;$y1<=$ymax;$y1+=2) {
                for (my $z1=$zmin;$z1<=$zmax;$z1+=2) {
                         $x1 = int $x1;
                        $y1 = int $y1;
                        $z1 = int $z1;
                        print FILE "$x1  $y1  $z1\n";
                }
        }
}
close FILE;

$file = "co.txt";
open (F1, $file);
my $box_file="$genpdbid"."_box.pdb";
open FILE,">$box_file";
my @b=<F1>;
close F1;
foreach my $b(@b) {
        my @point = split (/\s+/, $b);
        my $xyz = "                        ";
        my $x = $point[0];
        my $y = $point[1];
        my $z = $point[2];
        my $x1 = length($x);
        my $y1 = length($y);
        my $z1 = length($z);
        my $x2 = 8-$x1;
        my $y2 = 16-$y1;
        my $z2 = 24-$z1;
        substr ($xyz,$x2,$x1,$x);
        substr ($xyz,$y2,$y1,$y);
        substr ($xyz,$z2,$z1,$z);
        print FILE "HETATM      1  N   LEU A   1    $xyz  1.00  0.00 N\n";
}
print FILE "TER    4156      THR A 535\n";
close FILE;

my $count_box_main= &box("$box_file");
open READ, "$genpdbid"."_box.pdb" or die "Cant open Surface Box pdb file\n";
my @c=<READ>;
close READ;
open READ, "$genpdbid"."_sp.pdb" or die "Cant open Surface pdb file\n";
my @d=<READ>;
close READ;
my $int=0;

my @value;
my $t=0;
for(my $e=0;$e<scalar @c;$e++) {
            if ($c[$e]=~ m/^HETATM.*\s{7,10}(-?\d+)\s+(-?\d+)\s+(-?\d+)/) {
                my $x1 = $1;
                my $y1 = $2;
                my $z1 = $3;
                for(my $f=0;$f<scalar @d;$f++) {
                       if ($d[$f]=~ m/^ATOM.*(\w{3})\s(\w)\s{1,3}(\d{1,3})\s{4,7}(-?\d+\.\d+)\s*(-?\d+\.\d+)\s*(-?\d+\.\d+)/) {
                            my $x2 = $4;
                            my $y2 = $5;
                            my $z2 = $6;
                            #print "$x2\t$y2\t$z2\n";
                            if ((abs($x1-$x2)<0.68)&&(abs($y1-$y2)<0.68)&&(abs($z1-$z2)<0.68)) {
                                    $value[$t]="$x1\t$y1\t$z1\n";
                                    $t++;
                                    
                            }
                        }
               }
            }
            $int++;
        }
my @e;
co_split (@value);
co_sort (@value);
co_split (@e);
co_sort (@e);
co_split (@e);
co_sort (@e);
my %element;
 for my $value(@e) {
            $value=~s/\n//g;
            my $g=0;
            my ($x,$y,$z)= split (/\t/,$value);
            for my $sec_value(@e) {
                        $sec_value=~s/\n//g;
                        my ($x1,$y1,$z1)= split (/\t/,$sec_value);
                        if (($x1==$x)&&($y1==$y)) {
                                    $z_co[$g]=$z1;                                    
                                    $xyz_co="$x1\t$y1";
                                    $g++;
                        }
            }
            $z_co_min = min (@z_co);
            $z_co_max = max (@z_co);
            if (($z_co_min<$z_co_max)) {
                        @z_co=0;
                                 for (my $i=($z_co_min);$i<=($z_co_max);$i+=2) {
                                           if ($value eq "$xyz_co\t$i") {
                                                       $element{"$value\n"}=2;
                                            }
                                 }
                       }
 }
my $redefined_box_file = "redefined_box.pdb";
  open (F4, ">$redefined_box_file") or die "Cant write the redefined file\n";
  
  for my $d(@c) {
           $d =~ m/^HETATM.*\s{7,10}(-?\d+)\s+(-?\d+)\s+(-?\d+)/;
           my $x2 = $1;
           my $y2 = $2;
           my $z2 = $3;
           foreach my $key (keys %element) {
                      my ($x3,$y3,$z3)=split (/\t/,$key);
                      if (($x2==$x3)&&($y2==$y3)&&($z2==$z3)) {
                                 undef $d;
                      }
           }
           if ($d) {
                      print F4 "$d";
           }
  }
close F4;

my $count_box_redefined= &box("$redefined_box_file");
my $remaining_box=$count_box_main-$count_box_redefined;
my $surface_area = $remaining_box * 24;
$diss.="PREDICTED SURFACE AREA OF $m1 PROTEIN IS $surface_area Angstrom\n\n";
$diss.="Your output files are saved in the name $box_file and $genpdbid"."_sp.pdb";
$lgg=$fm_gr->Label(-text=>"$diss",-font=>[-size =>'9'])->pack(-side=>"top");
$txt1->delete('1.0','end');
$gop=$genpdbid."_sp.pdb";
open(KK,"$gop");
$f="";
while(<KK>)
{
$f.=$_;
}
$txt1->insert('1.0',"$f");
sub co_split {           
           foreach my $rand (@_) {
                      $rand =~s/\n//g;
                      my @hit=split(/\t/,$rand);
                      $rand = "$hit[2]\t$hit[0]\t$hit[1]\n"
           }
}

sub co_sort {
           @_= @_;
           my $f=0;           
           foreach my $value (sort {$a<=>$b} @_) {
                      $e[$f]=$value;
                      $f++;
           }
}



sub box {
	my ($filename) = @_;
	open READ, $filename or die "Cant open $filename pdb file\n";
	my @a=<READ>;
	my %hash;
	my ($x,$y,$z, $xyz);
	for(my $e=0;$e<scalar @a;$e++) {
		    if ($a[$e]=~ m/^HETATM.*\s{7,10}(-?\d+)\s+(-?\d+)\s+(-?\d+)/) {
		        $x .= "$1\n";
		        $y .= "$2\n";
		        $z .= "$3\n";
		        $xyz = "$1  $2  $3";
		        $hash{$xyz}=1;
		}
	}
	close READ;

		my @xco = split (/\n/,$x);
		my @yco = split (/\n/,$y);
		my @zco = split (/\n/,$z);
		my $xmin =  min (@xco);
		my $xmax =  max (@xco);
		my $ymin =  min (@yco);
		my $ymax =  max (@yco);
		my $zmin =  min (@zco);
		my $zmax =  max (@zco);
	    my $co1=0;
	    my $co2=1;    
	    my $co3=2;
	    my @element;
	    my $box_count=0;
	    for (my $i=$xmin;$i<=$xmax;$i+=2) {
		for (my $j=$ymin;$j<=$ymax;$j+=2) {
		    for (my $k=$zmax;$k>=$zmin;$k-=2) {
		            my $count = 0;
		            my $ijk1 = "$i  $j  $k";
		            my $j2 = $j+2;
		            my $ijk2 = "$i  $j2  $k";
		            my $i3 = $i+2;
		            my $ijk3 = "$i3  $j2  $k";
		            my $j4 = $j2-2;
		            my $ijk4 = "$i3  $j4  $k";
		            if (exists $hash{$ijk1}) {
		                    $count++;
		                    #print "one found\n";
		            }
		            if (exists $hash{$ijk2}) {
		                    $count++;
		                    #print "two found\n";
		            }
		            if (exists $hash{$ijk3}) {
		                    $count++;
		                    #print "three found\n";
		            }
		            if (exists $hash{$ijk4}) {
		                    $count++;
		                    #print "four found\n";
		            }  
		            if ($count==4) {
		                    my $count2=0;
		                    ($element1[$co1],$element1[$co2],$element1[$co3])=split(/\s+/,$ijk1);
		                    ($element2[$co1],$element2[$co2],$element2[$co3])=split(/\s+/,$ijk2);
		                    ($element3[$co1],$element3[$co2],$element3[$co3])=split(/\s+/,$ijk3);
		                    ($element4[$co1],$element4[$co2],$element4[$co3])=split(/\s+/,$ijk4);
		                    my $co11=$co1-3;
		                    my $co22=$co2-3;
		                    my $co33=$co3-3;		                    
		                    if (abs($element1[$co3]-$element1[$co33])==2) {
		                        $count2++;
		                    }
		                    if (abs($element2[$co3]-$element2[$co33])==2) {
		                        $count2++;
		                    }
		                    if (abs($element3[$co3]-$element3[$co33])==2) {
		                        $count2++;
		                    }
		                    if (abs($element4[$co3]-$element4[$co33])==2) {
		                        $count2++;
		                    }                            
		                    if ($count2==4) {
		                        $box_count++;
		                    }
		                    $co1+=3;
		                    $co2+=3;
		                    $co3+=3;
		            }
		    }
		}
	    }
	    return $box_count; 
  }


sub sort_and_findarms {                 ##SORTING AND FIND ARMSTRONG DIFFERENCE
           #my @inp=@_;
           my $fr = \@_;
           my @inp2;
           my @inp3;
           my $f=0;
           my $h=1;
           foreach my $value (sort {$a<=>$b} @_) {
                    my @gun = split (/\s+/, $value);
                    $inp2[$f]="$gun[0]";
                    $inp2[$h]="$gun[1]  $gun[2]  $gun[3]  $gun[4]  $gun[5]";
                    $f+=2;
                    $h+=2;
           }
           my $u=0;
           for (my $i=0;$i<scalar @inp2; $i+=2) {
                    my $k=$i+2;
                    my $l=$i+1;
                    if (abs($inp2[$i]-$inp2[$k])<$grid_dist) {
                        $inp2[$k]=$inp2[$i];              
                    }
                    my $s1=[split /\s+/, $inp2[$l]];
                    $fr->[$u]="$s1->[0]  $s1->[1]  $inp2[$i]  $s1->[2]  $s1->[3]  $s1->[4]";
                    $u++;
           }
}


sub surface {                       ##SURFACE POINT PREDICTION##
    my ($i,$j,$k,@inp)=@_;
    my $flag=0;
    foreach my $az (@inp) {                     
            my @xyz = split (/\s+/, $az);
            my %hash;
                    foreach my $file3(@inp) {
                            my @bz = split (/\s+/, $file3);
                            my $x1 = $bz[0];
                            my $y1 = $bz[1];
                            my $z1 = $bz[2];  
                            my $cod = "$bz[3]  $bz[4]  $bz[5]";
                            if (($j eq 'x')&&($k eq 'y')) {
                                if ($x1 eq $xyz[$i]) {
                                    delete ($hash{0});
                                    $hash{$y1} ="$x1  $z1  $cod";
                                    $flag=1;
                                 }
                            }
                            elsif (($j eq 'x')&&($k eq 'z')) {
                                if ($x1 eq $xyz[$i]) {
                                    delete ($hash{0});
                                    $hash{$z1} ="$x1  $y1  $cod"; 
                                    $flag=2;
                                }
                            }
                            
                            elsif (($j eq 'y')&&($k eq 'x')) {
                                if ($y1 eq $xyz[$i]) {
                                    delete ($hash{0});
                                    $hash{$x1} ="$y1  $z1  $cod";
                                    $flag=3;
                                }
                            }
                            
                            elsif (($j eq 'y')&&($k eq 'z')) {
                                if ($y1 eq $xyz[$i]) {
                                    delete ($hash{0});
                                    $hash{$z1} ="$x1  $y1  $cod";
                                    $flag=4;
                                }
                            }
                            
                            elsif (($j eq 'z')&&($k eq 'x')) {
                               if ($z1 eq $xyz[$i]) {
                                    delete ($hash{0});
                                    $hash{$x1} ="$y1  $z1  $cod";
                                    $flag=5;
                                }
                            }
                            
                            elsif (($j eq 'z')&&($k eq 'y')) {
                                if ($z1 eq $xyz[$i]) {
                                   delete ($hash{0});
                                   $hash{$y1} ="$x1  $z1  $cod";
                                    $flag=6;
                                }
                            }
                    }
        my $low = min keys %hash;
        my $high = max keys %hash;
        my $lt = [split /\s+/,$hash{$low}];
        my $ht = [split /\s+/,$hash{$high}];
        if (($flag==1)||($flag ==6)) {
            $surface_pts{"$lt->[2] $lt->[3]  $lt->[4]  $lt->[0]  $low  $lt->[1]<br>"}=2;
            $surface_pts{"$ht->[2] $ht->[3]  $ht->[4]  $ht->[0]  $high  $ht->[1]<br>"}=2;  
        }
        elsif (($flag==2)||($flag==4)) {
            $surface_pts{"$lt->[2] $lt->[3]  $lt->[4]  $lt->[0]  $lt->[1]  $low<br>"}=2;
            $surface_pts{"$ht->[2] $ht->[3]  $ht->[4]  $ht->[0]  $ht->[1]  $high<br>"}=2;  
        }
        elsif (($flag==3)||($flag==5)) {
            $surface_pts{"$lt->[2] $lt->[3]  $lt->[4]  $low  $lt->[0]  $lt->[1]<br>"}=2;
            $surface_pts{"$ht->[2] $ht->[3]  $ht->[4]  $high  $ht->[0]  $ht->[1]<br>"}=2;  
        }
    }
}
}
sub lpap
{
$txt1->delete('1.0','end');
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
open(RESS,$m);
@non=();
@dd=();
while(<RESS>)
{
if($_=~/^HETNAM/)
{
push(@non,substr($_,11,3));
}
}
for($i=0;$i<=scalar(@non);$i++)
{
for($j=$i+1;$j<=scalar(@non);$j++)
{
if($non[$i] eq $non[$j])
{
next;
}
else
{
push(@dd,$non[$i]);
$i=$j;
last;
}
}
}
push(@dd,$non[$#non]);
push(@dd,"HOH");
open(FG,$m);
@c=();
@chains=();
while(<FG>)
{
if($_=~/^COMPND/)
{
if($_=~/CHAIN:/)
{           
$_=~s/^COMPND   \d CHAIN:\s{1,}//;
$_=~s/;//g;
$_=~s/\s+//g;
@c=split(/,/,$_);
push(@chains,@c);
}
}
}
close FG;
my $dropdown_value;
my $dropdown = $fm_set->BrowseEntry(-label => "  Between    ",-variable => \$dropdown_value,-font=>[-size =>'10'])->pack(-anchor=>'nw',-side=>'left');
close FH;
foreach(@dd) 
{
$dropdown->insert('end', $_);
}
my $dropdown_value1;
my $dropdownq = $fm_set->BrowseEntry(-label => "     and CHAIN    ",-font=>[-size =>'10'],-variable => \$dropdown_valueq,)->pack(-anchor=>'nw',-side=>'left');
foreach(@chains) 
{
$dropdownq->insert('end', $_);
}
$but=$fm_set->Button(-text=>"Calculate",-command=>sub{$oo=$dropdown_value; $oo1=$dropdown_valueq;lpad($oo,$oo1)})->pack(-anchor=>'nw',-side=>'left');
$l3=$fm_set->Label(-text=>"    ",-font=>[-size =>'10'])->pack(-side=>"right");
$to=$fm_set->Entry(-width=>20)->pack(-side=>"right");
$l5a=$fm_set->Label(-text=>"To  ",-font=>[-size =>'10'])->pack(-side=>"right");
$from=$fm_set->Entry(-width=>20)->pack(-side=>"right");
$l5b=$fm_set->Label(-text=>"Cut-off:      From      ",-font=>[-size =>'10'])->pack(-side=>"right");
}
sub lpad
{
$fm_gr->destroy();
$fm_gr = $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_set);
$fm_gr1->destroy();
$fm_gr1= $mw_ppp->Frame(-relief=>'sunken',-borderwidth=>5);
$fm_gr1->pack(-side=>'top',-expand=>0,-fill=>'x',-after=>$fm_gr);
my($het,$chain)=@_;
$from1="";
$to1="";
$txt1->delete('1.0','end');
$txt->delete('1.0','end');
$from1=$from->get();
$to1=$to->get();
if($from1 != "" && $to1 != "")
{
$dish="";
$disa="";
@xcor=();
@ycor=();
@zcor=();
@xcor1=();
@ycor1=();
@zcor1=();
@hetres=();
@atmres=();
@hetname=();
@resname=();
@atmname=();
@hh=();
@aa=();
open(CAL,$m);
while(<CAL>)
{
if($_=~/^ATOM/)
{
if((substr($_,21,1) eq $chain))
{
$disa.=$_;
push(@xcor,substr($_,31,7));
push(@ycor,substr($_,39,7));
push(@zcor,substr($_,47,7));
push(@atmname,substr($_,13,4));
push(@resname,substr($_,17,3));
push(@atmres,substr($_,22,4));
push(@aa,substr($_,7,4));
}
}
}
close CAL;
open(CAL1,$m);
while(<CAL1>)
{
if($_=~/^HETATM/)
{
if((substr($_,17,3) eq $het))
{
$dish.=$_;
push(@hh,substr($_,7,4));
push(@xcor1,substr($_,31,7));
push(@ycor1,substr($_,39,7));
push(@zcor1,substr($_,47,7));
push(@hetname,substr($_,17,3));
push(@hetres,substr($_,22,4));
}
}
}
close CAL1;
$ji=0;
for($i=1;$i<=scalar(@xcor);$i++)
{
for($j=1;$j<=scalar(@xcor1);$j++)
{
$xans="";
$yans="";
$zans="";
$xans=($xcor[$j-1]-$xcor1[$i-1])*($xcor[$j-1]-$xcor1[$i-1]);
$yans=($ycor[$j-1]-$ycor1[$i-1])*($ycor[$j-1]-$ycor1[$i-1]);
$zans=($zcor[$j-1]-$zcor1[$i-1])*($zcor[$j-1]-$zcor1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
if($ans >= $from1 && $ans <= $to1)
{
$ji++;
}
}
}
$ji=$ji+1;
my $top = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($ji,8);
$arrayVar->{"0,0"} = "Hetra_Atom no.";
$arrayVar->{"0,1"} = "Hetra_Atom residue no.";
$arrayVar->{"0,2"} = "HETATM";
$arrayVar->{"0,3"} = "Protein atom no.";
$arrayVar->{"0,4"} = "Protein residue no.";
$arrayVar->{"0,5"} = "Residue";
$arrayVar->{"0,6"} = "Atom";
$arrayVar->{"0,7"} = "Distance";
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t=$top->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t->rowHeight(0,1); 
$t->colWidth(20,20,20,20,20,20); 
$t->colWidth(1=>20,0=>20,2=>20,3=>20,5=>20,4=>20,6=>20,7=>20);
$t->activate("1,0");
$t->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$ans="";
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
for($i=1;$i<=scalar(@xcor);$i++)
{
for($j=1;$j<=scalar(@xcor1);$j++)
{
$xans="";
$yans="";
$zans="";
$arrayVar->{"$k,0"} = $hh[$j-1];
$arrayVar->{"$k,1"} = $hetres[$j-1];
$arrayVar->{"$k,2"} = $hetname[$j-1];
$arrayVar->{"$k,3"} = $aa[$i-1];
$arrayVar->{"$k,4"} = $atmres[$i-1];
$arrayVar->{"$k,5"} = $resname[$i-1];
$arrayVar->{"$k,6"} = $atmname[$i-1];
$xans=($xcor[$j-1]-$xcor1[$i-1])*($xcor[$j-1]-$xcor1[$i-1]);
$yans=($ycor[$j-1]-$ycor1[$i-1])*($ycor[$j-1]-$ycor1[$i-1]);
$zans=($zcor[$j-1]-$zcor1[$i-1])*($zcor[$j-1]-$zcor1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
if($ans >= $from1 && $ans <= $to1)
{
$arrayVar->{"$k,7"} = $ans;
$k++;
}
}
}
$txt1->insert('1.0',"$dish");
$txt->insert('1.0',"$disa");
}
else
{
$dish="";
$disa="";
@xcor=();
@ycor=();
@zcor=();
@xcor1=();
@ycor1=();
@zcor1=();
@hetres=();
@atmres=();
@hetname=();
@resname=();
@atmname=();
@hh=();
@aa=();
open(CAL,$m);
while(<CAL>)
{
if($_=~/^ATOM/)
{
if((substr($_,21,1) eq $chain))
{
$disa.=$_;
push(@xcor,substr($_,31,7));
push(@ycor,substr($_,39,7));
push(@zcor,substr($_,47,7));
push(@atmname,substr($_,13,4));
push(@resname,substr($_,17,3));
push(@atmres,substr($_,22,4));
push(@aa,substr($_,7,4));
}
}
}
close CAL;
open(CAL1,$m);
while(<CAL1>)
{
if($_=~/^HETATM/)
{
if((substr($_,17,3) eq $het))
{
$dish.=$_;
push(@hh,substr($_,7,4));
push(@xcor1,substr($_,31,7));
push(@ycor1,substr($_,39,7));
push(@zcor1,substr($_,47,7));
push(@hetname,substr($_,17,3));
push(@hetres,substr($_,22,4));
}
}
}
close CAL1;
$n=scalar(@xcor)*scalar(@xcor1);
$n++;
my $top1 = $fm_gr;
my $arrayVar = {};
my ($rows,$cols)=($n,8);
$arrayVar->{"0,0"} = "Hetra_Atom no.";
$arrayVar->{"0,1"} = "Hetra_Atom residue no.";
$arrayVar->{"0,2"} = "HETATM";
$arrayVar->{"0,3"} = "Protein atom no.";
$arrayVar->{"0,4"} = "Protein residue no.";
$arrayVar->{"0,5"} = "Residue";
$arrayVar->{"0,6"} = "Atom";
$arrayVar->{"0,7"} = "Distance";
sub colSub
{
my $col = shift;
return "OddCol" if( $col > 0 && $col%2) ;}
my $t1=$top1->Scrolled('Spreadsheet',-rows =>$rows,-cols =>$cols, -rowheight => 2,
-height =>21,-titlerows => 1, -titlecols => 1,-variable => $arrayVar,-coltagcommand => \&colSub,-colstretchmode => 'last',
-flashmode => 1,-flashtime => 2,-wrap=>1,-rowstretchmode => 'last',-selectmode => 'extended',-selecttype=>'cell',
-selecttitles => 0,-drawmode => 'slow',-scrollbars=>'se',-sparsearray=>0)->pack(-expand => 1, -fill => 'both');
$t1->rowHeight(0,1); 
$t1->colWidth(20,20,20,20,20,20); 
$t1->colWidth(1=>20,0=>20,2=>20,3=>20,5=>20,4=>20,6=>20,7=>20);
$t1->activate("1,0");
$t1->tagConfigure('OddCol', -bg => '#E09662', -fg => 'black');
$t1->tagConfigure('title', -bg => '#FFC966', -fg => 'black', -relief => 'sunken');
$k=1; 
$ans="";
sub round {
  my $number = shift || 0;
  my $dec = 10 ** (shift || 0);
  return int( $dec * $number + .5 * ($number <=> 0)) / $dec;
}
for($i=1;$i<=scalar(@xcor);$i++)
{
for($j=1;$j<=scalar(@xcor1);$j++)
{
$xans="";
$yans="";
$zans="";
$arrayVar->{"$k,0"} = $hh[$j-1];
$arrayVar->{"$k,1"} = $hetres[$j-1];
$arrayVar->{"$k,2"} = $hetname[$j-1];
$arrayVar->{"$k,3"} = $aa[$i-1];
$arrayVar->{"$k,4"} = $atmres[$i-1];
$arrayVar->{"$k,5"} = $resname[$i-1];
$arrayVar->{"$k,6"} = $atmname[$i-1];
$xans=($xcor[$j-1]-$xcor1[$i-1])*($xcor[$j-1]-$xcor1[$i-1]);
$yans=($ycor[$j-1]-$ycor1[$i-1])*($ycor[$j-1]-$ycor1[$i-1]);
$zans=($zcor[$j-1]-$zcor1[$i-1])*($zcor[$j-1]-$zcor1[$i-1]);
$ans=sqrt($xans+$yans+$zans);
$ans=round($ans,3);
$arrayVar->{"$k,7"} = $ans;
$k++;
}
}
$txt1->insert('1.0',"$dish");
$txt->insert('1.0',"$disa");
}
}
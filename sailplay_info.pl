#!/usr/bin/perl -w
#info FileDescription =SailPlay promocodes check plugin for nagios or centreon
#info FileVersion=1.0
#info LegalCopyright=Akulich Dmitry akulich.d@gmail.com
use strict;
use warnings;
use JSON;
use utf8;
use LWP::UserAgent ();
use Getopt::Std;
use vars qw($opt_K $opt_d $opt_w $opt_c $opt_V);
my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
my $log="sailplay.log";
my $filehandle;
my $proxy = "";
#'http://10.160.236.1:8080';
my $ua = LWP::UserAgent->new(timeout => 10);
my $response;
my $json_data;
my $content;
my $count;
my $total;
my $free;
my $used;
my $prname;
my $tw;
my $tc;
#getting options
getopts("K:d:w:c:V:");
# Initialise Vars
if ($opt_V){
	open ($filehandle,'>>',$log) or die "cant open log file\n";
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime();
	$year=$year+1900;
	print $filehandle "--verbose is on!\n";
	print $filehandle "------------------\nNew session started at $hour\:$min - $mday $months[$mon]  $year\n-----------------\n";
	print $filehandle "-Going to read params-\n";
};
my $token = $opt_K ||
    die "Key must be set ... usage: -K token <-d store department id> <-w promocodes left > <-c promocodes left> <-V verbose logging to file sailplay.log>\n";

my $id = $opt_d || '0';
my $status = 0;
my $problem;
my $perf = "|";
my $warning = $opt_w || 500;
my $critical = $opt_c || 100;
my $rq = "https://sailplay.ru/api/v2/promocodes/groups/list/?token=$token&store_department_id=$id";
if ($opt_V){
	print $filehandle "-Params was readed-\n";
	print $filehandle "-id=$id warning=$warning critical=$critical verbose=$opt_V proxy=$proxy Token=$token-\n request=$rq";
	print $filehandle "-Going to getting data from server-\n";
};
#get data from server

if ($proxy ne "") {
	$ua->proxy(['http', 'https'], $proxy);
};
 
  $response = $ua->get($rq);
 

if ($response->is_success) {
	$json_data=$response->decoded_content;
    if ($opt_V){
	print $filehandle "-That data we got-\n$json_data\n-----------------\n";
	}
}
else {
	if ($opt_V){
		print $filehandle "-We got nothing-\n Exit \n";
		close ($filehandle);
	}
    die $response->status_line;
}

if ($opt_V){
	print $filehandle "-Going to convert json to perl vars-\n";
};
#open json

$content = decode_json($json_data);
if ($content->{status} ne 'ok') {
	if ($opt_V){
		print $filehandle "-We got nothing in json-\n Exit\n";
		close ($filehandle);
	};
	die "We got nothing in json\n";
}
$count=@{$content->{groups}->{enabled}};
if ($opt_V){
	print $filehandle "-We got $count promos in json-\n";
};
if ($opt_V){
	print $filehandle "-Going to check promos-\n";
}

for my $key (0..$count-1) {
		$prname=$content->{groups}->{enabled}->[$key]->{name};
		if ($opt_V){
			print $filehandle "-Checking promo group $key name=$prname  \n";
		}
		$total=$content->{groups}->{enabled}->[$key]->{total_count};
		$used=$content->{groups}->{enabled}->[$key]->{receipted_count};
		$free=$content->{groups}->{enabled}->[$key]->{unused_count};
		if ($free <= $critical) {
			$status=2;
			$problem .="Critical! In promo group $prname less than $critical coupons left - $free\n";
			$tw=$total-$warning;
			$tc=$total-$critical;
			$perf .=$prname."_total=$total;;;; $prname"."_used=$used;$tw;$tc;$total; ";
			if ($opt_V){
				print $filehandle "-Current status $status;-\n-Problem = $problem-\n-Perf=$perf-\n";
			}
			next;
		}
		if ($free <= $warning) {
			if ($status<1) {$status=1;};
			$problem .="Warning! In promo group $prname less than $warning coupons left - $free\n";
			$tw=$total-$warning;
			$tc=$total-$critical;
			$perf .=$prname."_total=$total;;;; $prname"."_used=$used;$tw;$tc;$total; ";
			if ($opt_V){
				print $filehandle "-Current status $status;-\n-Problem = $problem-\n-Perf=$perf-\n";
			}
			next;
		}
		if ($free > $warning) {
			$problem .="OK! In promo group $prname more than $warning coupons left - $free\n";
			$tw=$total-$warning;
			$tc=$total-$critical;
			$perf .=$prname."_total=$total;;;; $prname"."_used=$used;$tw;$tc;$total; ";
			if ($opt_V){
				print $filehandle "-Current status $status;-\n-Problem = $problem-\n-Perf=$perf-\n";
			}
			next;
		}
};
#Going to make a report
print "$problem $perf\n";
exit $status;
	

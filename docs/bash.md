# Bashing Bluetooth
##### A very gentle introduction to basic command-line data processing

 * [Downloading Data](#downloading-data)
    * [Downloading Data from Data.World](#downloading-data-from-data.world)
    * [Downloading Data from Socrata](#downloading-data-from-socrata)
 * [Looking at the Data](#looking-at-the-data)
    * [cat and less](#cat-and-less)
    * [du and wc](#du-and-wc)
    * [head and tail](#heads-and-tails)
 * [Filtering and Processing the Data](#filtering-and-processing-the-data)
    * [grep and cut](#grep-and-cut)
    * [sort and diff](#sort-and-diff)
    * [read and bash](#bash-itself)
    * [sed and awk](#sed-and-awk)
 * [Performing Calculations](#performing-calculations)


## Downloading Data

### Downloading Data from Data.World

Let's download an Individual Address File (IAF) from Data.World; this is the raw vehicle location data. The IAF dataset is located here:

- https://data.world/ctr/atd-awam-iaf

The data is stored in separate files, one for every day. Suppose we want to download the data file for January 1st, 2016 (`Austin_bt_01-01-2016.csv`). We can preview this data here:

- https://data.world/ctr/atd-awam-iaf/file/Austin_bt_01-01-2016.csv

To download the data manually you can click on the "export" button and choose "Download file". Alternatively, you can select the option "Copy URL, Python/Pandas or R Code" to get snippets for accessing the file programmatically. Here is the URL for the file `Austin_bt_01-01-2016.csv`:

-   https://query.data.world/s/d3kmd7piji2yyvhsp6drj7dwf

To download this file from the command-line we can use the `curl` or `wget` programs. `wget` is specifically designed to download web pages from the Internet, while the `curl` program is a more general utility which exposes the functionality of the liburl library (cf. [cURL](https://en.wikipedia.org/wiki/CURL)), but both can easily be used to download a single file. Here are the corresponding commands:

```shell
$ curl "https://query.data.world/s/d3kmd7piji2yyvhsp6drj7dwf" --output Austin_bt_01-01-2016.csv
```
```shell
$ wget "https://query.data.world/s/d3kmd7piji2yyvhsp6drj7dwf" --output-document=Austin_bt_01-01-2016.csv
```

This should produce a local file called `Austin_bt_01-01-2016.csv` in your current directory.

## Looking at the data

### cat and less

Now that we've downloaded a data file, let's look at what we have. The most straight-forward way to do this is to use the `cat` command (short for concatenate). Althought `cat` is most useful for combining the content of several files (i.e. concatenating them), it can also be used to display the contents of a single file:

```shell
$ cat Austin_bt_01-01-2016.csv
record_id,host_read_time,field_device_read_time,reader_identifier,device_address
65dc72ef2b5802900576727bd584bb30,1451649600,1451649351,south_1st_stassney,ae:c9:45:28:5f
ff02e661588edc2384746d6144193dc1,1451649600,1451649351,anderson_mill_us183,20:e0:db:94:fd
76534ff4dcf445e5cf89be73dcbf483a,1451649600,1451649351,congress_slaughter,19:6b:33:b0:08
8012fdb4503cc287e99af27e69f7bfa2,1451649601,1451649352,south_1st_wm_cannon,e4:62:6e:f0:45
452d487687d37a4328ba61cb31403c4a,1451649602,1451649353,ih_35_riverside,80:c9:65:f8:9c
8fc90112f968529f837c6fe821f3beaf,1451649602,1451649354,lavaca_6th,29:3e:ef:0b:ce
469efa8973fbce822408d697f19f25f2,1451649603,1451649354,guadalupe_21st,bf:cc:02:eb:c3
860910897d30d5d76f25636ce425639e,1451649603,1451643409,south_1st_oltorf,14:50:b9:b8:e5
1c1c0ec122eea8a595b56a28521a48b3,1451649604,1451649355,mlk_lavaca,c0:0e:43:31:5c

[...]
```

Note that in general you may want to hold off on running this command on a strange file. In this case, since the `Austin_bt_01-01-2016.csv` is fairly large, `cat` will overflow your screen with data and possibly take some time before it finishes. A better option in this case would be to use `less`. This program (which is an enhanced version of `more`) is what's called [a pager](https://en.wikipedia.org/wiki/Terminal_pager) - a program that lets you view but (not modify) a text file (i.e. it lets you "page through" the document). Here is the command:

```shell
$ less Austin_bt_01-01-2016.csv
```

The `less` program has many different commands (check out [the Wikipedia page](https://en.wikipedia.org/wiki/Less_(Unix)) for some references) but for now it's probably enough to know that you can scroll up and down line-by-line using the arrow keys and you can press `q` to quit.

### du and wc

Let's start by looking at how much data we have. The `du` command (disk usage) will tell us how many kilobytes of data are in the file:

```shell
$ du Austin_bt_01-01-2016.csv
20856   Austin_bt_01-01-2016.csv
```

Apparently there are 20856 bytes of raw data for January 1st, 2016. We can use the `--human-readable` option to give us the size in a more appropriate denomination (e.g. megabytes or gigabytes for larger files):

```shell
$ du --human-readable Austin_bt_01-01-2016.csv
21M Austin_bt_01-01-2016.csv
```

So the file is (approximately) 21 megabytes. Suppose instead of bytes we want to know how many rows of data we have. For this we can use the `wc` command (word count). `wc` counts the number of lines, words, and lines in a text file:

```shell
$ wc Austin_bt_01-01-2016.csv
  245254   245254 21353408 Austin_bt_01-01-2016.csv
```

This tells us that `Austin_bt_01-01-2016.csv` contains 245254 lines, 245254 words, and 21353408 bytes. Notice that the line count and the word count are equal here. This is because there are no spaces in the data file, so each line is considered a single word. Since we're only interested in the number of data rows right now, we can have `wc` produce only the line count:

```shell
$ wc -l Austin_bt_01-01-2016.csv
245254 Austin_bt_01-01-2016.csv
```

If we want *just* the number of lines without echoing the filename, we can use [I/O redirection](https://en.wikipedia.org/wiki/Redirection_(computing); either input redirection):

```shell
$ wc -l < Austin_bt_01-01-2016.csv
245254
```

or output redirection:

```shell
$ cat Austin_bt_01-01-2016.csv | wc -l
245254
```

### head and tail

Two more useful tools for looking at the contents of large files are `head` and `tail`. The `head` utility shows you the beginning of a file and the `tail` utility shows you the end of a file. In order to see the first 5 lines of data we could use the following `head` command:

```shell
$ head -5 Austin_bt_01-01-2016.csv
record_id,host_read_time,field_device_read_time,reader_identifier,device_address
65dc72ef2b5802900576727bd584bb30,1451649600,1451649351,south_1st_stassney,ae:c9:45:28:5f
ff02e661588edc2384746d6144193dc1,1451649600,1451649351,anderson_mill_us183,20:e0:db:94:fd
76534ff4dcf445e5cf89be73dcbf483a,1451649600,1451649351,congress_slaughter,19:6b:33:b0:08
8012fdb4503cc287e99af27e69f7bfa2,1451649601,1451649352,south_1st_wm_cannon,e4:62:6e:f0:45
```

Notice that the data file has a header row which contains the column names. To get just the column names we would use this command:

```shell
$ head -5 Austin_bt_01-01-2016.csv
record_id,host_read_time,field_device_read_time,reader_identifier,device_address
```

Alternative, we could use this `tail` command to see the last 5 lines of data:

```shell
$ tail -5 Austin_bt_01-01-2016.csv
ff9a94e4b0ed99bb480f3a79e7ff741d,1451735995,1451729782,south_1st_oltorf,f0:b8:9c:9b:41
5e2320797cd2fa798b9b9118d740d633,1451735997,1451735750,congress_6th,9f:b7:7b:ad:6e
35c3d315b68540e15611a913d9735209,1451735998,1451735751,congress_slaughter,cc:94:8a:1f:eb
389aedfd2189530594abfd0639143371,1451735999,1451735752,anderson_mill_us183,d4:4a:88:80:0d
08610e1527b28a4040b2f1907f89be5c,1451735999,1451735752,5th_red_river,1d:1e:8b:52:f1
```

Now suppose we want to strip off the header row and just look at the data rows. The `tail` command has an option that does just that. By using the `-n+2` option we will get the tail of the file starting at the second row. Combining `head` and `tail` we can get easily get the first ten rows of data (excluding the header):

```shell
$ head -11 Austin_bt_01-01-2016.csv | tail -n+2
65dc72ef2b5802900576727bd584bb30,1451649600,1451649351,south_1st_stassney,ae:c9:45:28:5f
ff02e661588edc2384746d6144193dc1,1451649600,1451649351,anderson_mill_us183,20:e0:db:94:fd
76534ff4dcf445e5cf89be73dcbf483a,1451649600,1451649351,congress_slaughter,19:6b:33:b0:08
8012fdb4503cc287e99af27e69f7bfa2,1451649601,1451649352,south_1st_wm_cannon,e4:62:6e:f0:45
452d487687d37a4328ba61cb31403c4a,1451649602,1451649353,ih_35_riverside,80:c9:65:f8:9c
8fc90112f968529f837c6fe821f3beaf,1451649602,1451649354,lavaca_6th,29:3e:ef:0b:ce
469efa8973fbce822408d697f19f25f2,1451649603,1451649354,guadalupe_21st,bf:cc:02:eb:c3
860910897d30d5d76f25636ce425639e,1451649603,1451643409,south_1st_oltorf,14:50:b9:b8:e5
1c1c0ec122eea8a595b56a28521a48b3,1451649604,1451649355,mlk_lavaca,c0:0e:43:31:5c
41372e5ea1f27f513f87f4d3092ccfe0,1451649604,1451649355,south_1st_wm_cannon,9f:68:7a:91:2d
```

## Filtering and Processing the Data

### grep and cut

The `grep` command is probably one of the most useful tools ever invented. My mnemonic for `grep` was "***g***et ***re***gular ex***p***ression", but I think it actually stands for "global regular expression print" (related: [In Unix, what do some obscurely named commands stand for?](https://kb.iu.edu/d/abnd)
). It lets you filter and extract text based on patterns called [regular expressions](https://en.wikipedia.org/wiki/Regular_expression). For example, suppose we want to extract every row containing the text `south_1st_stassney `. Then we could run the following command:

```shell
$ grep south_1st_stassney Austin_bt_01-01-2016.csv
65dc72ef2b5802900576727bd584bb30,1451649600,1451649351,south_1st_stassney,ae:c9:45:28:5f
7a5c8f73960500423668d5edf2b2812c,1451649699,1451649449,south_1st_stassney,ae:c9:45:28:5f
527c17c04ef3b1ec96edb0d28673201e,1451649773,1451649524,south_1st_stassney,ae:c9:45:28:5f
36834ff79c80c576d944c0c9d0741395,1451649994,1451649750,south_1st_stassney,ae:c9:45:28:5f
8135a4a9d9df0a923d62815f61bc0f96,1451650025,1451649780,south_1st_stassney,e4:f0:bd:b5:b2
55121c5c27f5ec82165f7ae842fdac51,1451650076,1451649832,south_1st_stassney,ae:c9:45:28:5f
55f0186e592e4bb9b4ecd2b6cf9c7484,1451650140,1451649896,south_1st_stassney,ae:c9:45:28:5f
732ed4f27d8b316b22f9937f29a22bb0,1451650197,1451649953,south_1st_stassney,97:e1:be:50:04
5e7af28546a02b8aa303142e7f2f7edb,1451650248,1451650003,south_1st_stassney,5e:62:6c:e3:2b
5143161172f2e71ae93bb857beda0d2a,1451650299,1451650055,south_1st_stassney,8a:80:cd:59:58

[...]
```

Alternatively, suppose we just want to know *how many* rows match this location. Then we could combine `grep` with `wc` as follows:

```shell
$ grep south_1st_stassney Austin_bt_01-01-2016.csv | wc -l
1905
```

Thus we see that there are 1905 records at South 1st and Stassney on January 1st, 2016. We can also *negate* a pattern to get the lines the *don't* match a given string. Let's see how many rows of data we have for locations *other than* South 1st and Stassney:

```shell
$ grep -v south_1st_stassney Austin_bt_01-01-2016.csv | wc -l
243349
```

If we want to extract columns instead of rows, we can use the `cut` command. This command allows us to specify a delimiter (i.e. a column or field separator) such as a comma, specify which rows to include in its output. For example, suppose we just wanted to get the column of reader identifiers. Since this is the fourth column, we would use this command:

```shell
$ cut -d, -f4 Austin_bt_01-01-2016.csv
reader_identifier
south_1st_stassney
anderson_mill_us183
congress_slaughter
south_1st_wm_cannon
ih_35_riverside
lavaca_6th
guadalupe_21st
south_1st_oltorf
mlk_lavaca

[...]
```

### sort and diff

Combining our previous `cut` command the `sort` command, we can get a sorted list of the unique reader identifiers, although in this case it probably makes sense to use `tail` to remove the column names first:

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | cut -d, -f4 | sort -u
2nd_san_jacinto
51st_manor
51st_mueller
51st_springdale
51st_us183
5th_red_river
7th_plesant_valley
7th_shady
7th_springdale
Lamar_BrodieOaks
Lamar_and_Manchca_Barton_skyway
anderson_mill_bethany
anderson_mill_spicewood_parkway
anderson_mill_us183
bartonsprings_robertelee
bartonsprings_robertelee_south

[...]
```

Since this may be useful information to have around, we may want to write it to a file for later:

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | cut -d, -f4 | sort -u > Austin_bt_01-01-2016-readers.csv
```

While we're at it, we might want to create a similar file for the devices (column 5):

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | cut -d, -f5 | sort -u > Austin_bt_01-01-2016-devices.csv
```

We can also use the `sort` command to sort by different columns. The syntax is similar to the syntax of the `cut` command in that we specify a delimiter/field-separator (in this case a comma) and indicate which field or fields we're interested in. For example, if we sort by device address all of rows corresponding to the same device should be grouped together, making it easy to identify the path that each device takes through the sensor network:

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | sort -t, -k5,1
809d17c92edb8c52cea26fac03bcadb6,1451705524,1451705278,fm2222_riverplace,00:00:17:be:8d
ee0c59e48dad03a65c7af88e8d59f411,1451705589,1451705344,fm2222_riverplace,00:00:17:be:8d
e5f4d48932fc8f27c322205848aeb0e6,1451734703,1451734198,lamar_rundberg,00:02:d5:ce:57
8ff19aa5f394db7e89277a6ee34db12f,1451689717,1451689469,us183_metropolis,00:02:e8:ed:64
ad31e48b29b4d1423b9969431646e153,1451700038,1451699793,51st_mueller,00:03:2d:a7:2f
4f5782245672f6677c93bb71ec97ae33,1451721884,1451721640,congress_slaughter,00:04:d6:90:e4
7e9883946649faa6aa901a20ed64e6c6,1451688603,1451688356,congress_benwhite,00:04:d6:90:e4
c592f07310e96bb2ea90767a30ab7bfd,1451688068,1451687821,tx71_ross,00:04:d6:90:e4
33f07b6349672bd443240fd86cc007ad,1451710327,1451710080,lamar_morrow,00:06:9d:3f:43
3b01da87bc649a4ea3fdd6b1ab2d7561,1451705466,1451705221,lamar_airport,00:06:9d:3f:43

[...]
```

The rows should have already been sorted in order by the time host device read time (column 1), but if we want to make sure that they're sorted by time after being sorted by device address, we can make that explicit as follows:

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | sort -t, -k5,1 -k1,1
809d17c92edb8c52cea26fac03bcadb6,1451705524,1451705278,fm2222_riverplace,00:00:17:be:8d
ee0c59e48dad03a65c7af88e8d59f411,1451705589,1451705344,fm2222_riverplace,00:00:17:be:8d
e5f4d48932fc8f27c322205848aeb0e6,1451734703,1451734198,lamar_rundberg,00:02:d5:ce:57
8ff19aa5f394db7e89277a6ee34db12f,1451689717,1451689469,us183_metropolis,00:02:e8:ed:64
ad31e48b29b4d1423b9969431646e153,1451700038,1451699793,51st_mueller,00:03:2d:a7:2f
4f5782245672f6677c93bb71ec97ae33,1451721884,1451721640,congress_slaughter,00:04:d6:90:e4
7e9883946649faa6aa901a20ed64e6c6,1451688603,1451688356,congress_benwhite,00:04:d6:90:e4
c592f07310e96bb2ea90767a30ab7bfd,1451688068,1451687821,tx71_ross,00:04:d6:90:e4
33f07b6349672bd443240fd86cc007ad,1451710327,1451710080,lamar_morrow,00:06:9d:3f:43
3b01da87bc649a4ea3fdd6b1ab2d7561,1451705466,1451705221,lamar_airport,00:06:9d:3f:43

[...]
```

It looks like the output is the same in both cases, but if we want to be sure we can check with the `diff` command:

```shell
$ diff <(tail -n+2 Austin_bt_01-01-2016.csv | sort -t, -k5 -k1,1) <(tail -n+2 Austin_bt_01-01-2016.csv | sort -t, -k5)
```

If `diff` produces no output put then the two files (or streams) must be the same. Otherwise it will produce a list of the differences between the two files.


Since this sorted list may be useful for later as well, we may want to write it to a file too:

```shell
$ tail -n+2 Austin_bt_01-01-2016.csv | sort -t, -k5 -k1,1 > Austin_bt_01-01-2016-sorted.csv
```

You may notice that many devices only appear one or twice in the data set. This could happen for any number of reasons: the device may only have ever come within range of a single sensor, the device may have entered the network but then subsequently been turned off, the device may have been read once or twice and then paired or otherwise become undiscoverable, or the device may have changed its MAC address (possibly in order to avoid detection). You'll probably have to do a significant amount of cleaning before being able to derive useful information from the raw data.


### read and bash

The `bash` shell isn't just a place for running other programs; it's also got its own simple programming language which you can use to combine commands in more complicated ways. In particular, `bash` supports variables, logical tests (e.g. `if-then` statements) and looping constructs (`for` loops and `while` loops). For example, you can use a `while` loop in combination with the `read` command to iterate over the lines of a file:

```shell
$ cat Austin_bt_01-01-2016.csv | while read line; do echo $line; done
record_id,host_read_time,field_device_read_time,reader_identifier,device_address
65dc72ef2b5802900576727bd584bb30,1451649600,1451649351,south_1st_stassney,ae:c9:45:28:5f
ff02e661588edc2384746d6144193dc1,1451649600,1451649351,anderson_mill_us183,20:e0:db:94:fd
76534ff4dcf445e5cf89be73dcbf483a,1451649600,1451649351,congress_slaughter,19:6b:33:b0:08
8012fdb4503cc287e99af27e69f7bfa2,1451649601,1451649352,south_1st_wm_cannon,e4:62:6e:f0:45
452d487687d37a4328ba61cb31403c4a,1451649602,1451649353,ih_35_riverside,80:c9:65:f8:9c
8fc90112f968529f837c6fe821f3beaf,1451649602,1451649354,lavaca_6th,29:3e:ef:0b:ce
469efa8973fbce822408d697f19f25f2,1451649603,1451649354,guadalupe_21st,bf:cc:02:eb:c3
860910897d30d5d76f25636ce425639e,1451649603,1451643409,south_1st_oltorf,14:50:b9:b8:e5
1c1c0ec122eea8a595b56a28521a48b3,1451649604,1451649355,mlk_lavaca,c0:0e:43:31:5c

[...]
```
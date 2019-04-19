# DownloadStationTorrentUploadBlocker
Small script, that allows to set and enforce upload speed limit to 0 for torrents in Synology Download Station.

In some countries it is fully legal to download copyrighted materials (like videos etc) as long as you do not source them. The BitTorrent protocol is designed in such way, that even while downloading a file everyone automatically sources that part of the file that has been already downloaded. Without limiting upload speed to zero it is possible to get trouble and claims from internet provider. When using this extention you become so called leacher, which is bad for bittorrent community - you should use it only if necessery to avoid breaking local law!

By using this small script, ideally as Scheduled Task, Synology Download Station will not upload anything at all, even while downloading. As the underlaying transmission client is started only for the time there is something to download or upload, it makes a lot of sense to leave at least one file with permanent seeding enabled (some linux image for example) - this will prevent synology to stop transmission daemon.

In order to activate this script, put it somewhere i.e. under admin user home directory, and start it *as root* from Tasks, for example every 5 minutes. Root acces is not needed for the basic operation of the script, however it is mandatory for checking if transmission daemon is running, and to kill the daemon (which is running as root) should the setting of upload speed to zero would not work.

Script works in following way:
1. it checks if the daemon is running - if not, it terminates
2. it checks if upload speed is set to 0 and limit is enforced by using domain socket from transmission daemon - if it is already set, it terminates
3. it sets the upload limit to 0 and enables it
4. it checks if the limit was correctly set - if not, it kills the running transmission daemon ti make sure that transmission will not break the law.

Happy using :)

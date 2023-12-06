# cordonaksnodepool
## Unschedule nodepools in an AKS cluster

#### Install
```bash
git clone https://github.com/dqmicrosoft/cordonaksnodepool.git
cd cordonaksnodepool
chmod +x unschedule.sh
./unschedule.sh
```
#### Usage

To cordon Nodepool 
```bash
./unschedule -p <value> -c"
```
To Uncordon Nodepool
```bash
./unschedule -p <value> -u"
```
To list Nodepools
```bash
./unschedule -g <value> -n <value> -l"
```

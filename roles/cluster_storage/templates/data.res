resource data {
#syncer { rate 100M; }
net {
#protocol C;     
     allow-two-primaries;
     after-sb-0pri discard-zero-changes;
     after-sb-1pri discard-secondary;
     after-sb-2pri disconnect;
}
startup { 
     become-primary-on both; 
}
     device /dev/drbd0;
     disk /dev/sdb;
     meta-disk internal;
 
on backend1 {
          address 192.168.255.1:7788;
         }
 
on backend2 {
          address 192.168.255.2:7788;
         }
}

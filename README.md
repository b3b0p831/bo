```log
  524   cat asm.out | grep "00401450 <_main>:" -A 76 | \\ngrep '[0-9a-f]:' | \\ngrep -v 'file' | \\ncut -f2 -d: | \\ncut -f1-6 -d' ' | \\ntr -s ' ' | \\ntr '\t' ' ' | \\nsed 's/ $//g' | \\nsed 's/ /\\x/g' | \\ntr -d '\n' | \\nsed 's/^/"/' | \\nsed 's/$/"/g'\n
  525  i686-w64-mingw32-gcc -fno-stack-protector -no-pie -m32 -o shell.exe shell.c -lws2_32
  526  cp bo.exe /Volumes/Desktop/bo.exe
  527  nc 192.168.128.2 8080
  528  nc 192.168.128.2 8080
  529  nc 192.168.128.2 8080
  530  cp bo.exe /Volumes/Desktop/bo.exe
  531  i686-w64-mingw32-gcc -fno-stack-protector -no-pie -m32 -o shell.exe shell.c -lws2_32
  532  cp bo.exe /Volumes/Desktop/bo.exe
```


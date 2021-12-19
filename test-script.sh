make splc
#bin/splc test/1.spl
#make clean


# for i in {1..15}
# do
# if (($i < 10))
# then
#   echo "test $i : "
# bin/splc test-ex/test_2_r0"$i".spl
# else
#   echo "test $i : "
# bin/splc test-ex/test_2_r"$i".spl
# fi
# done

# for i in {1..10}
# do
# if (($i < 10))
# then
#   echo "test $i : "
# bin/splc test/test_2_r0"$i".spl
# else
#   echo "test $i : "
# bin/splc test/test_2_r"$i".spl
# fi
# done

 for i in {1..10}
 do
 if (($i < 10))
 then
   echo "test $i : "
 bin/splc test/test"$i".spl
 else
   echo "test $i : "
 bin/splc test/test"$i".spl
 fi
 done

# for i in {1..15}
# do
# if (($i < 10))
# then
#   echo "test $i : "
# bin/splc test/test_2_r0"$i".spl
# else
#   echo "test $i : "
# bin/splc test/test_2_r"$i".spl
# fi
# done

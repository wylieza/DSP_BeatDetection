Tempo Detection Project for DSP

Tempo Charicteristics to exploit:
 - Tempo is somewhat constant (in best case, constant for entire song)
 - Tempo is periodic -> Auto correlation should spike in accorance to this
 - Beat usually corresponds to a peak in power out

 - The AC result is mirrored, so remove the second half
 - The AC result is less accurate in the beginning and more accurate nearer the end
 - If the sample time is too long or two short, the AC result has a higher proportion of problematic information

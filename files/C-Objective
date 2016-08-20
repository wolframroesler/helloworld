/* Hello World in Objective-C.
** Since the standard implementation is identical to K&R C,
** a version that says hello to a set of people passed on
** the command line is shown here.
*/

#include <stdio.h>
#include <objpak.h>
int main(int argc,char **argv)
{
    id set = [Set new];
    argv++;while (--argc) [set add:[String str:*argv++]];
    [set do:{ :each | printf("hello, %s!\n",[each str]); }];
    return 0;
}

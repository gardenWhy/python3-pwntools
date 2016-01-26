<%
  from pwnlib.shellcraft import thumb
  from pwnlib.util import lists, packing, misc
%>
<%page args="string, append_null=True"/>
<%docstring>
Pushes a string onto the stack without using
null bytes or newline characters.

Args:
  string (bytes, str): The string to push.
  append_null (bool): Whether to append a single NULL-byte before pushing.

Examples:
    >>>> with context.local():
    ...    context.arch = 'thumb'
    ...    print(enhex(asm(shellcraft.pushstr('Hello\nWorld!', True))))
    81ea010102b4dff8041001e0726c642102b4dff8041001e06f0a576f02b4dff8041001e048656c6c02b4
    >>>> with context.local():
    ...    context.arch = 'thumb'
    ...    print(enhex(asm(shellcraft.pushstr('', True))))
    81ea010102b4
    >>>> with context.local():
    ...    context.arch = 'thumb'
    ...    print(enhex(asm(shellcraft.pushstr(b'\x00', False))))
    81ea010102b4

</%docstring>
<%
    string = misc.force_bytes(string)

    if append_null:
        string += b'\x00'
    if not string:
        return

%>\
    /* push ${repr(string)} */
% for word in lists.group(4, string, 'fill', b'\x00')[::-1]:
    ${thumb.mov('r1', packing.unpack(word))}
    push {r1}
% endfor

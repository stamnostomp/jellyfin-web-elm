(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (typeof x.$ === 'undefined')
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.a4.au === region.bm.au)
	{
		return 'on line ' + region.a4.au;
	}
	return 'on lines ' + region.a4.au + ' through ' + region.bm.au;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**_UNUSED/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cs,
		impl.cZ,
		impl.cV,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**_UNUSED/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**/
	var node = args['node'];
	//*/
	/**_UNUSED/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS
//
// For some reason, tabs can appear in href protocols and it still works.
// So '\tjava\tSCRIPT:alert("!!!")' and 'javascript:alert("!!!")' are the same
// in practice. That is why _VirtualDom_RE_js and _VirtualDom_RE_js_html look
// so freaky.
//
// Pulling the regular expressions out to the top level gives a slight speed
// boost in small benchmarks (4-10%) but hoisting values to reduce allocation
// can be unpredictable in large programs where JIT may have a harder time with
// functions are not fully self-contained. The benefit is more that the js and
// js_html ones are so weird that I prefer to see them near each other.


var _VirtualDom_RE_script = /^script$/i;
var _VirtualDom_RE_on_formAction = /^(on|formAction$)/i;
var _VirtualDom_RE_js = /^\s*j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:/i;
var _VirtualDom_RE_js_html = /^\s*(j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:|d\s*a\s*t\s*a\s*:\s*t\s*e\s*x\s*t\s*\/\s*h\s*t\s*m\s*l\s*(,|;))/i;


function _VirtualDom_noScript(tag)
{
	return _VirtualDom_RE_script.test(tag) ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return _VirtualDom_RE_on_formAction.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return _VirtualDom_RE_js.test(value)
		? /**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return _VirtualDom_RE_js_html.test(value)
		? /**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlJson(value)
{
	return (typeof _Json_unwrap(value) === 'string' && _VirtualDom_RE_js_html.test(_Json_unwrap(value)))
		? _Json_wrap(
			/**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		) : value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		N: func(record.N),
		a5: record.a5,
		a1: record.a1
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.N;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.a5;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.a1) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cs,
		impl.cZ,
		impl.cV,
		function(sendToApp, initialModel) {
			var view = impl.c$;
			/**/
			var domNode = args['node'];
			//*/
			/**_UNUSED/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cs,
		impl.cZ,
		impl.cV,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.a3 && impl.a3(sendToApp)
			var view = impl.c$;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.b9);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.aP) && (_VirtualDom_doc.title = title = doc.aP);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.cI;
	var onUrlRequest = impl.cJ;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		a3: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.bL === next.bL
							&& curr.bt === next.bt
							&& curr.bI.a === next.bI.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		cs: function(flags)
		{
			return A3(impl.cs, flags, _Browser_getUrl(), key);
		},
		c$: impl.c$,
		cZ: impl.cZ,
		cV: impl.cV
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { cp: 'hidden', cc: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { cp: 'mozHidden', cc: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { cp: 'msHidden', cc: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { cp: 'webkitHidden', cc: 'webkitvisibilitychange' }
		: { cp: 'hidden', cc: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		bS: _Browser_getScene(),
		b0: {
			b2: _Browser_window.pageXOffset,
			b3: _Browser_window.pageYOffset,
			c0: _Browser_doc.documentElement.clientWidth,
			co: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		c0: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		co: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			bS: {
				c0: node.scrollWidth,
				co: node.scrollHeight
			},
			b0: {
				b2: node.scrollLeft,
				b3: node.scrollTop,
				c0: node.clientWidth,
				co: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			bS: _Browser_getScene(),
			b0: {
				b2: x,
				b3: y,
				c0: _Browser_doc.documentElement.clientWidth,
				co: _Browser_doc.documentElement.clientHeight
			},
			ch: {
				b2: x + rect.left,
				b3: y + rect.top,
				c0: rect.width,
				co: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



// SEND REQUEST

var _Http_toTask = F3(function(router, toTask, request)
{
	return _Scheduler_binding(function(callback)
	{
		function done(response) {
			callback(toTask(request.cj.a(response)));
		}

		var xhr = new XMLHttpRequest();
		xhr.addEventListener('error', function() { done($elm$http$Http$NetworkError_); });
		xhr.addEventListener('timeout', function() { done($elm$http$Http$Timeout_); });
		xhr.addEventListener('load', function() { done(_Http_toResponse(request.cj.b, xhr)); });
		$elm$core$Maybe$isJust(request.b$) && _Http_track(router, xhr, request.b$.a);

		try {
			xhr.open(request.cx, request.c_, true);
		} catch (e) {
			return done($elm$http$Http$BadUrl_(request.c_));
		}

		_Http_configureRequest(xhr, request);

		request.b9.a && xhr.setRequestHeader('Content-Type', request.b9.a);
		xhr.send(request.b9.b);

		return function() { xhr.c = true; xhr.abort(); };
	});
});


// CONFIGURE

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.bs; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}
	xhr.timeout = request.cY.a || 0;
	xhr.responseType = request.cj.d;
	xhr.withCredentials = request.b5;
}


// RESPONSES

function _Http_toResponse(toBody, xhr)
{
	return A2(
		200 <= xhr.status && xhr.status < 300 ? $elm$http$Http$GoodStatus_ : $elm$http$Http$BadStatus_,
		_Http_toMetadata(xhr),
		toBody(xhr.response)
	);
}


// METADATA

function _Http_toMetadata(xhr)
{
	return {
		c_: xhr.responseURL,
		cT: xhr.status,
		cU: xhr.statusText,
		bs: _Http_parseHeaders(xhr.getAllResponseHeaders())
	};
}


// HEADERS

function _Http_parseHeaders(rawHeaders)
{
	if (!rawHeaders)
	{
		return $elm$core$Dict$empty;
	}

	var headers = $elm$core$Dict$empty;
	var headerPairs = rawHeaders.split('\r\n');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf(': ');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3($elm$core$Dict$update, key, function(oldValue) {
				return $elm$core$Maybe$Just($elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}
	return headers;
}


// EXPECT

var _Http_expect = F3(function(type, toBody, toValue)
{
	return {
		$: 0,
		d: type,
		b: toBody,
		a: toValue
	};
});

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		d: expect.d,
		b: expect.b,
		a: function(x) { return func(expect.a(x)); }
	};
});

function _Http_toDataView(arrayBuffer)
{
	return new DataView(arrayBuffer);
}


// BODY and PARTS

var _Http_emptyBody = { $: 0 };
var _Http_pair = F2(function(a, b) { return { $: 0, a: a, b: b }; });

function _Http_toFormData(parts)
{
	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}
	return formData;
}

var _Http_bytesToBlob = F2(function(mime, bytes)
{
	return new Blob([bytes], { type: mime });
});


// PROGRESS

function _Http_track(router, xhr, tracker)
{
	// TODO check out lengthComputable on loadstart event

	xhr.upload.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Sending({
			cS: event.loaded,
			bU: event.total
		}))));
	});
	xhr.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Receiving({
			cM: event.loaded,
			bU: event.lengthComputable ? $elm$core$Maybe$Just(event.total) : $elm$core$Maybe$Nothing
		}))));
	});
}var $elm$core$Basics$EQ = 1;
var $elm$core$Basics$GT = 2;
var $elm$core$Basics$LT = 0;
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var $elm$core$Basics$False = 1;
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Maybe$Nothing = {$: 1};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 0:
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 1) {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 1:
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 2:
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.g) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.i),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.i);
		} else {
			var treeLen = builder.g * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.j) : builder.j;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.g);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.i) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.i);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{j: nodeList, g: (len / $elm$core$Array$branchFactor) | 0, i: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = 0;
var $elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 1, a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = $elm$core$Basics$identity;
var $elm$url$Url$Http = 0;
var $elm$url$Url$Https = 1;
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {bo: fragment, bt: host, bG: path, bI: port_, bL: protocol, bM: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 1) {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		0,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		1,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = $elm$core$Basics$identity;
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return 0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0;
		return A2($elm$core$Task$map, tagger, task);
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			A2($elm$core$Task$map, toMessage, task));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$Main$JellyfinMsg = $elm$core$Basics$identity;
var $author$project$JellyfinUI$MediaDetailMsg = function (a) {
	return {$: 7, a: a};
};
var $author$project$JellyfinUI$ServerSettingsMsg = function (a) {
	return {$: 8, a: a};
};
var $author$project$JellyfinUI$TMDBDataReceived = function (a) {
	return {$: 19, a: a};
};
var $author$project$JellyfinUI$WindowResized = F2(
	function (a, b) {
		return {$: 21, a: a, b: b};
	});
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $author$project$JellyfinAPI$defaultServerConfig = {aU: $elm$core$Maybe$Nothing, aV: 'http://localhost:8096', a8: $elm$core$Maybe$Nothing};
var $elm$core$Dict$RBEmpty_elm_builtin = {$: -2};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $elm$http$Http$BadStatus_ = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $elm$http$Http$BadUrl_ = function (a) {
	return {$: 0, a: a};
};
var $elm$http$Http$GoodStatus_ = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var $elm$http$Http$NetworkError_ = {$: 2};
var $elm$http$Http$Receiving = function (a) {
	return {$: 1, a: a};
};
var $elm$http$Http$Sending = function (a) {
	return {$: 0, a: a};
};
var $elm$http$Http$Timeout_ = {$: 1};
var $elm$core$Maybe$isJust = function (maybe) {
	if (!maybe.$) {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === -2) {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1) {
					case 0:
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 1:
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$Black = 1;
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: -1, a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = 0;
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === -1) && (!right.a)) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === -1) && (!left.a)) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === -1) && (!left.a)) && (left.d.$ === -1)) && (!left.d.a)) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === -2) {
			return A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1) {
				case 0:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 1:
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === -1) && (dict.d.$ === -1)) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === -1) && (dict.d.$ === -1)) && (dict.e.$ === -1)) {
		if ((dict.e.d.$ === -1) && (!dict.e.d.a)) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				0,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr === 1) {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === -1) && (dict.d.$ === -1)) && (dict.e.$ === -1)) {
		if ((dict.d.d.$ === -1) && (!dict.d.d.a)) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				0,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr === 1) {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === -1) && (!left.a)) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === -1) && (right.a === 1)) {
					if (right.d.$ === -1) {
						if (right.d.a === 1) {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === -1) && (dict.d.$ === -1)) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor === 1) {
			if ((lLeft.$ === -1) && (!lLeft.a)) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === -1) {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === -2) {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === -1) && (left.a === 1)) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === -1) && (!lLeft.a)) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === -1) {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === -1) {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === -1) {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (!_v0.$) {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $elm$http$Http$expectStringResponse = F2(
	function (toMsg, toResult) {
		return A3(
			_Http_expect,
			'',
			$elm$core$Basics$identity,
			A2($elm$core$Basics$composeR, toResult, toMsg));
	});
var $elm$core$Result$mapError = F2(
	function (f, result) {
		if (!result.$) {
			var v = result.a;
			return $elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return $elm$core$Result$Err(
				f(e));
		}
	});
var $elm$http$Http$BadBody = function (a) {
	return {$: 4, a: a};
};
var $elm$http$Http$BadStatus = function (a) {
	return {$: 3, a: a};
};
var $elm$http$Http$BadUrl = function (a) {
	return {$: 0, a: a};
};
var $elm$http$Http$NetworkError = {$: 2};
var $elm$http$Http$Timeout = {$: 1};
var $elm$http$Http$resolve = F2(
	function (toResult, response) {
		switch (response.$) {
			case 0:
				var url = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadUrl(url));
			case 1:
				return $elm$core$Result$Err($elm$http$Http$Timeout);
			case 2:
				return $elm$core$Result$Err($elm$http$Http$NetworkError);
			case 3:
				var metadata = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadStatus(metadata.cT));
			default:
				var body = response.b;
				return A2(
					$elm$core$Result$mapError,
					$elm$http$Http$BadBody,
					toResult(body));
		}
	});
var $elm$http$Http$expectJson = F2(
	function (toMsg, decoder) {
		return A2(
			$elm$http$Http$expectStringResponse,
			toMsg,
			$elm$http$Http$resolve(
				function (string) {
					return A2(
						$elm$core$Result$mapError,
						$elm$json$Json$Decode$errorToString,
						A2($elm$json$Json$Decode$decodeString, decoder, string));
				}));
	});
var $elm$http$Http$emptyBody = _Http_emptyBody;
var $elm$http$Http$Request = function (a) {
	return {$: 1, a: a};
};
var $elm$http$Http$State = F2(
	function (reqs, subs) {
		return {bO: reqs, bY: subs};
	});
var $elm$http$Http$init = $elm$core$Task$succeed(
	A2($elm$http$Http$State, $elm$core$Dict$empty, _List_Nil));
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$http$Http$updateReqs = F3(
	function (router, cmds, reqs) {
		updateReqs:
		while (true) {
			if (!cmds.b) {
				return $elm$core$Task$succeed(reqs);
			} else {
				var cmd = cmds.a;
				var otherCmds = cmds.b;
				if (!cmd.$) {
					var tracker = cmd.a;
					var _v2 = A2($elm$core$Dict$get, tracker, reqs);
					if (_v2.$ === 1) {
						var $temp$router = router,
							$temp$cmds = otherCmds,
							$temp$reqs = reqs;
						router = $temp$router;
						cmds = $temp$cmds;
						reqs = $temp$reqs;
						continue updateReqs;
					} else {
						var pid = _v2.a;
						return A2(
							$elm$core$Task$andThen,
							function (_v3) {
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A2($elm$core$Dict$remove, tracker, reqs));
							},
							$elm$core$Process$kill(pid));
					}
				} else {
					var req = cmd.a;
					return A2(
						$elm$core$Task$andThen,
						function (pid) {
							var _v4 = req.b$;
							if (_v4.$ === 1) {
								return A3($elm$http$Http$updateReqs, router, otherCmds, reqs);
							} else {
								var tracker = _v4.a;
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A3($elm$core$Dict$insert, tracker, pid, reqs));
							}
						},
						$elm$core$Process$spawn(
							A3(
								_Http_toTask,
								router,
								$elm$core$Platform$sendToApp(router),
								req)));
				}
			}
		}
	});
var $elm$http$Http$onEffects = F4(
	function (router, cmds, subs, state) {
		return A2(
			$elm$core$Task$andThen,
			function (reqs) {
				return $elm$core$Task$succeed(
					A2($elm$http$Http$State, reqs, subs));
			},
			A3($elm$http$Http$updateReqs, router, cmds, state.bO));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (!_v0.$) {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$http$Http$maybeSend = F4(
	function (router, desiredTracker, progress, _v0) {
		var actualTracker = _v0.a;
		var toMsg = _v0.b;
		return _Utils_eq(desiredTracker, actualTracker) ? $elm$core$Maybe$Just(
			A2(
				$elm$core$Platform$sendToApp,
				router,
				toMsg(progress))) : $elm$core$Maybe$Nothing;
	});
var $elm$http$Http$onSelfMsg = F3(
	function (router, _v0, state) {
		var tracker = _v0.a;
		var progress = _v0.b;
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$filterMap,
					A3($elm$http$Http$maybeSend, router, tracker, progress),
					state.bY)));
	});
var $elm$http$Http$Cancel = function (a) {
	return {$: 0, a: a};
};
var $elm$http$Http$cmdMap = F2(
	function (func, cmd) {
		if (!cmd.$) {
			var tracker = cmd.a;
			return $elm$http$Http$Cancel(tracker);
		} else {
			var r = cmd.a;
			return $elm$http$Http$Request(
				{
					b5: r.b5,
					b9: r.b9,
					cj: A2(_Http_mapExpect, func, r.cj),
					bs: r.bs,
					cx: r.cx,
					cY: r.cY,
					b$: r.b$,
					c_: r.c_
				});
		}
	});
var $elm$http$Http$MySub = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$http$Http$subMap = F2(
	function (func, _v0) {
		var tracker = _v0.a;
		var toMsg = _v0.b;
		return A2(
			$elm$http$Http$MySub,
			tracker,
			A2($elm$core$Basics$composeR, toMsg, func));
	});
_Platform_effectManagers['Http'] = _Platform_createManager($elm$http$Http$init, $elm$http$Http$onEffects, $elm$http$Http$onSelfMsg, $elm$http$Http$cmdMap, $elm$http$Http$subMap);
var $elm$http$Http$command = _Platform_leaf('Http');
var $elm$http$Http$subscription = _Platform_leaf('Http');
var $elm$http$Http$request = function (r) {
	return $elm$http$Http$command(
		$elm$http$Http$Request(
			{b5: false, b9: r.b9, cj: r.cj, bs: r.bs, cx: r.cx, cY: r.cY, b$: r.b$, c_: r.c_}));
};
var $elm$http$Http$get = function (r) {
	return $elm$http$Http$request(
		{b9: $elm$http$Http$emptyBody, cj: r.cj, bs: _List_Nil, cx: 'GET', cY: $elm$core$Maybe$Nothing, b$: $elm$core$Maybe$Nothing, c_: r.c_});
};
var $author$project$TMDBData$TMDBResponse = function (categories) {
	return {u: categories};
};
var $author$project$JellyfinAPI$Category = F3(
	function (id, name, items) {
		return {E: id, cu: items, aw: name};
	});
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$map3 = _Json_map3;
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $author$project$JellyfinAPI$CastMember = F5(
	function (id, name, character, profileUrl, order) {
		return {bg: character, E: id, aw: name, bF: order, aI: profileUrl};
	});
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $elm$json$Json$Decode$map5 = _Json_map5;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
var $elm$json$Json$Decode$maybe = function (decoder) {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder),
				$elm$json$Json$Decode$succeed($elm$core$Maybe$Nothing)
			]));
};
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$TMDBData$castMemberDecoder = A6(
	$elm$json$Json$Decode$map5,
	$author$project$JellyfinAPI$CastMember,
	A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'character', $elm$json$Json$Decode$string),
	$elm$json$Json$Decode$maybe(
		A2($elm$json$Json$Decode$field, 'profileUrl', $elm$json$Json$Decode$string)),
	A2($elm$json$Json$Decode$field, 'order', $elm$json$Json$Decode$int));
var $author$project$JellyfinAPI$CrewMember = F5(
	function (id, name, job, department, profileUrl) {
		return {bk: department, E: id, bv: job, aw: name, aI: profileUrl};
	});
var $author$project$TMDBData$crewMemberDecoder = A6(
	$elm$json$Json$Decode$map5,
	$author$project$JellyfinAPI$CrewMember,
	A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'job', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'department', $elm$json$Json$Decode$string),
	$elm$json$Json$Decode$maybe(
		A2($elm$json$Json$Decode$field, 'profileUrl', $elm$json$Json$Decode$string)));
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$json$Json$Decode$map6 = _Json_map6;
var $author$project$JellyfinAPI$Movie = 0;
var $author$project$JellyfinAPI$Music = 2;
var $author$project$JellyfinAPI$TVShow = 1;
var $elm$json$Json$Decode$fail = _Json_fail;
var $author$project$TMDBData$decodeMediaType = function (str) {
	switch (str) {
		case 'Movie':
			return $elm$json$Json$Decode$succeed(0);
		case 'TVShow':
			return $elm$json$Json$Decode$succeed(1);
		case 'Music':
			return $elm$json$Json$Decode$succeed(2);
		default:
			return $elm$json$Json$Decode$fail('Unknown media type: ' + str);
	}
};
var $author$project$TMDBData$mediaTypeDecoder = A2($elm$json$Json$Decode$andThen, $author$project$TMDBData$decodeMediaType, $elm$json$Json$Decode$string);
var $author$project$TMDBData$mediaItemDecoder = A2(
	$elm$json$Json$Decode$andThen,
	function (baseItem) {
		return A6(
			$elm$json$Json$Decode$map5,
			F5(
				function (description, backdropUrl, genres, cast, directors) {
					return _Utils_update(
						baseItem,
						{bc: backdropUrl, be: cast, aD: description, aE: directors, as: genres});
				}),
			$elm$json$Json$Decode$maybe(
				A2($elm$json$Json$Decode$field, 'description', $elm$json$Json$Decode$string)),
			$elm$json$Json$Decode$maybe(
				A2($elm$json$Json$Decode$field, 'backdropUrl', $elm$json$Json$Decode$string)),
			A2(
				$elm$json$Json$Decode$field,
				'genres',
				$elm$json$Json$Decode$list($elm$json$Json$Decode$string)),
			A2(
				$elm$json$Json$Decode$field,
				'cast',
				$elm$json$Json$Decode$list($author$project$TMDBData$castMemberDecoder)),
			A2(
				$elm$json$Json$Decode$field,
				'directors',
				$elm$json$Json$Decode$list($author$project$TMDBData$crewMemberDecoder)));
	},
	A7(
		$elm$json$Json$Decode$map6,
		F6(
			function (id, title, type_, imageUrl, year, rating) {
				return {bc: $elm$core$Maybe$Nothing, be: _List_Nil, aD: $elm$core$Maybe$Nothing, aE: _List_Nil, as: _List_Nil, E: id, aG: imageUrl, aJ: rating, aP: title, aQ: type_, aS: year};
			}),
		A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
		A2($elm$json$Json$Decode$field, 'title', $elm$json$Json$Decode$string),
		A2($elm$json$Json$Decode$field, 'type_', $author$project$TMDBData$mediaTypeDecoder),
		A2($elm$json$Json$Decode$field, 'imageUrl', $elm$json$Json$Decode$string),
		A2($elm$json$Json$Decode$field, 'year', $elm$json$Json$Decode$int),
		A2($elm$json$Json$Decode$field, 'rating', $elm$json$Json$Decode$float)));
var $author$project$TMDBData$categoryDecoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$JellyfinAPI$Category,
	A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'items',
		$elm$json$Json$Decode$list($author$project$TMDBData$mediaItemDecoder)));
var $author$project$TMDBData$tmdbResponseDecoder = A2(
	$elm$json$Json$Decode$map,
	$author$project$TMDBData$TMDBResponse,
	A2(
		$elm$json$Json$Decode$field,
		'categories',
		$elm$json$Json$Decode$list($author$project$TMDBData$categoryDecoder)));
var $author$project$TMDBData$fetchTMDBData = function (toMsg) {
	return $elm$http$Http$get(
		{
			cj: A2($elm$http$Http$expectJson, toMsg, $author$project$TMDBData$tmdbResponseDecoder),
			c_: '/data/movies.json'
		});
};
var $elm$browser$Browser$Dom$getViewport = _Browser_withWindow(_Browser_getViewport);
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$MediaDetail$init = _Utils_Tuple2(
	{T: $elm$core$Maybe$Nothing, J: false, av: $elm$core$Maybe$Nothing},
	$elm$core$Platform$Cmd$none);
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$ServerSettings$init = _Utils_Tuple2(
	{
		Q: A2($elm$core$Maybe$withDefault, '', $author$project$JellyfinAPI$defaultServerConfig.aU),
		aa: $author$project$JellyfinAPI$defaultServerConfig.aV,
		S: $elm$core$Maybe$Nothing,
		af: false,
		ag: false,
		a2: $author$project$JellyfinAPI$defaultServerConfig,
		Z: A2($elm$core$Maybe$withDefault, '', $author$project$JellyfinAPI$defaultServerConfig.a8)
	},
	$elm$core$Platform$Cmd$none);
var $elm$core$Platform$Cmd$map = _Platform_map;
var $elm$core$Basics$round = _Basics_round;
var $author$project$JellyfinUI$init = function () {
	var allGenres = _List_fromArray(
		['Sci-Fi', 'Adventure', 'Drama', 'Action', 'Romance', 'Mystery', 'Comedy', 'Fantasy', 'Thriller', 'Horror', 'Documentary']);
	var _v0 = $author$project$ServerSettings$init;
	var serverSettingsModel = _v0.a;
	var serverSettingsCmd = _v0.b;
	var _v1 = $author$project$MediaDetail$init;
	var mediaDetailModel = _v1.a;
	var mediaDetailCmd = _v1.b;
	return _Utils_Tuple2(
		{aq: allGenres, u: _List_Nil, ab: $elm$core$Dict$empty, ad: $elm$core$Maybe$Nothing, I: false, J: true, K: false, L: false, ai: mediaDetailModel, aj: '', ay: $elm$core$Maybe$Nothing, B: $elm$core$Maybe$Nothing, C: $elm$core$Maybe$Nothing, a2: $author$project$JellyfinAPI$defaultServerConfig, aN: serverSettingsModel, x: 1200},
		$elm$core$Platform$Cmd$batch(
			_List_fromArray(
				[
					A2($elm$core$Platform$Cmd$map, $author$project$JellyfinUI$MediaDetailMsg, mediaDetailCmd),
					A2($elm$core$Platform$Cmd$map, $author$project$JellyfinUI$ServerSettingsMsg, serverSettingsCmd),
					$author$project$TMDBData$fetchTMDBData($author$project$JellyfinUI$TMDBDataReceived),
					A2(
					$elm$core$Task$perform,
					function (vp) {
						return A2(
							$author$project$JellyfinUI$WindowResized,
							$elm$core$Basics$round(vp.b0.c0),
							$elm$core$Basics$round(vp.b0.co));
					},
					$elm$browser$Browser$Dom$getViewport)
				])));
}();
var $author$project$Main$init = function (_v0) {
	var _v1 = $author$project$JellyfinUI$init;
	var jellyfinModel = _v1.a;
	var jellyfinCmd = _v1.b;
	return _Utils_Tuple2(
		{ah: jellyfinModel},
		A2($elm$core$Platform$Cmd$map, $elm$core$Basics$identity, jellyfinCmd));
};
var $elm$core$Platform$Sub$map = _Platform_map;
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$browser$Browser$Events$Window = 1;
var $elm$browser$Browser$Events$MySub = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var $elm$browser$Browser$Events$State = F2(
	function (subs, pids) {
		return {bH: pids, bY: subs};
	});
var $elm$browser$Browser$Events$init = $elm$core$Task$succeed(
	A2($elm$browser$Browser$Events$State, _List_Nil, $elm$core$Dict$empty));
var $elm$browser$Browser$Events$nodeToKey = function (node) {
	if (!node) {
		return 'd_';
	} else {
		return 'w_';
	}
};
var $elm$browser$Browser$Events$addKey = function (sub) {
	var node = sub.a;
	var name = sub.b;
	return _Utils_Tuple2(
		_Utils_ap(
			$elm$browser$Browser$Events$nodeToKey(node),
			name),
		sub);
};
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === -2) {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _v0) {
				stepState:
				while (true) {
					var list = _v0.a;
					var result = _v0.b;
					if (!list.b) {
						return _Utils_Tuple2(
							list,
							A3(rightStep, rKey, rValue, result));
					} else {
						var _v2 = list.a;
						var lKey = _v2.a;
						var lValue = _v2.b;
						var rest = list.b;
						if (_Utils_cmp(lKey, rKey) < 0) {
							var $temp$rKey = rKey,
								$temp$rValue = rValue,
								$temp$_v0 = _Utils_Tuple2(
								rest,
								A3(leftStep, lKey, lValue, result));
							rKey = $temp$rKey;
							rValue = $temp$rValue;
							_v0 = $temp$_v0;
							continue stepState;
						} else {
							if (_Utils_cmp(lKey, rKey) > 0) {
								return _Utils_Tuple2(
									list,
									A3(rightStep, rKey, rValue, result));
							} else {
								return _Utils_Tuple2(
									rest,
									A4(bothStep, lKey, lValue, rValue, result));
							}
						}
					}
				}
			});
		var _v3 = A3(
			$elm$core$Dict$foldl,
			stepState,
			_Utils_Tuple2(
				$elm$core$Dict$toList(leftDict),
				initialResult),
			rightDict);
		var leftovers = _v3.a;
		var intermediateResult = _v3.b;
		return A3(
			$elm$core$List$foldl,
			F2(
				function (_v4, result) {
					var k = _v4.a;
					var v = _v4.b;
					return A3(leftStep, k, v, result);
				}),
			intermediateResult,
			leftovers);
	});
var $elm$browser$Browser$Events$Event = F2(
	function (key, event) {
		return {bn: event, bw: key};
	});
var $elm$browser$Browser$Events$spawn = F3(
	function (router, key, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var actualNode = function () {
			if (!node) {
				return _Browser_doc;
			} else {
				return _Browser_window;
			}
		}();
		return A2(
			$elm$core$Task$map,
			function (value) {
				return _Utils_Tuple2(key, value);
			},
			A3(
				_Browser_on,
				actualNode,
				name,
				function (event) {
					return A2(
						$elm$core$Platform$sendToSelf,
						router,
						A2($elm$browser$Browser$Events$Event, key, event));
				}));
	});
var $elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3($elm$core$Dict$foldl, $elm$core$Dict$insert, t2, t1);
	});
var $elm$browser$Browser$Events$onEffects = F3(
	function (router, subs, state) {
		var stepRight = F3(
			function (key, sub, _v6) {
				var deads = _v6.a;
				var lives = _v6.b;
				var news = _v6.c;
				return _Utils_Tuple3(
					deads,
					lives,
					A2(
						$elm$core$List$cons,
						A3($elm$browser$Browser$Events$spawn, router, key, sub),
						news));
			});
		var stepLeft = F3(
			function (_v4, pid, _v5) {
				var deads = _v5.a;
				var lives = _v5.b;
				var news = _v5.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, pid, deads),
					lives,
					news);
			});
		var stepBoth = F4(
			function (key, pid, _v2, _v3) {
				var deads = _v3.a;
				var lives = _v3.b;
				var news = _v3.c;
				return _Utils_Tuple3(
					deads,
					A3($elm$core$Dict$insert, key, pid, lives),
					news);
			});
		var newSubs = A2($elm$core$List$map, $elm$browser$Browser$Events$addKey, subs);
		var _v0 = A6(
			$elm$core$Dict$merge,
			stepLeft,
			stepBoth,
			stepRight,
			state.bH,
			$elm$core$Dict$fromList(newSubs),
			_Utils_Tuple3(_List_Nil, $elm$core$Dict$empty, _List_Nil));
		var deadPids = _v0.a;
		var livePids = _v0.b;
		var makeNewPids = _v0.c;
		return A2(
			$elm$core$Task$andThen,
			function (pids) {
				return $elm$core$Task$succeed(
					A2(
						$elm$browser$Browser$Events$State,
						newSubs,
						A2(
							$elm$core$Dict$union,
							livePids,
							$elm$core$Dict$fromList(pids))));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$sequence(makeNewPids);
				},
				$elm$core$Task$sequence(
					A2($elm$core$List$map, $elm$core$Process$kill, deadPids))));
	});
var $elm$browser$Browser$Events$onSelfMsg = F3(
	function (router, _v0, state) {
		var event = _v0.bn;
		var key = _v0.bw;
		var toMessage = function (_v2) {
			var subKey = _v2.a;
			var _v3 = _v2.b;
			var node = _v3.a;
			var name = _v3.b;
			var decoder = _v3.c;
			return _Utils_eq(subKey, key) ? A2(_Browser_decodeEvent, decoder, event) : $elm$core$Maybe$Nothing;
		};
		var messages = A2($elm$core$List$filterMap, toMessage, state.bY);
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Platform$sendToApp(router),
					messages)));
	});
var $elm$browser$Browser$Events$subMap = F2(
	function (func, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var decoder = _v0.c;
		return A3(
			$elm$browser$Browser$Events$MySub,
			node,
			name,
			A2($elm$json$Json$Decode$map, func, decoder));
	});
_Platform_effectManagers['Browser.Events'] = _Platform_createManager($elm$browser$Browser$Events$init, $elm$browser$Browser$Events$onEffects, $elm$browser$Browser$Events$onSelfMsg, 0, $elm$browser$Browser$Events$subMap);
var $elm$browser$Browser$Events$subscription = _Platform_leaf('Browser.Events');
var $elm$browser$Browser$Events$on = F3(
	function (node, name, decoder) {
		return $elm$browser$Browser$Events$subscription(
			A3($elm$browser$Browser$Events$MySub, node, name, decoder));
	});
var $elm$browser$Browser$Events$onResize = function (func) {
	return A3(
		$elm$browser$Browser$Events$on,
		1,
		'resize',
		A2(
			$elm$json$Json$Decode$field,
			'target',
			A3(
				$elm$json$Json$Decode$map2,
				func,
				A2($elm$json$Json$Decode$field, 'innerWidth', $elm$json$Json$Decode$int),
				A2($elm$json$Json$Decode$field, 'innerHeight', $elm$json$Json$Decode$int))));
};
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $author$project$MediaDetail$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$JellyfinUI$subscriptions = function (model) {
	return $elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				A2(
				$elm$core$Platform$Sub$map,
				$author$project$JellyfinUI$MediaDetailMsg,
				$author$project$MediaDetail$subscriptions(model.ai)),
				$elm$browser$Browser$Events$onResize($author$project$JellyfinUI$WindowResized)
			]));
};
var $author$project$Main$subscriptions = function (model) {
	return A2(
		$elm$core$Platform$Sub$map,
		$elm$core$Basics$identity,
		$author$project$JellyfinUI$subscriptions(model.ah));
};
var $author$project$MediaDetail$MediaDetailReceived = function (a) {
	return {$: 1, a: a};
};
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$JellyfinUI$findCategory = F2(
	function (categoryId, categories) {
		return $elm$core$List$head(
			A2(
				$elm$core$List$filter,
				function (cat) {
					return _Utils_eq(cat.E, categoryId);
				},
				categories));
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var $author$project$MockData$mockCategories = _List_fromArray(
	[
		{
		E: 'continue-watching',
		cu: _List_fromArray(
			[
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Captain Sarah Chen', E: 'cast1', aw: 'Emma Stone', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Dr. Marcus Wells', E: 'cast2', aw: 'John Boyega', bF: 1, aI: $elm$core$Maybe$Nothing},
						{bg: 'Engineer Raj Kumar', E: 'cast3', aw: 'Dev Patel', bF: 2, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A thrilling sci-fi series about explorers who venture into a mysterious void at the edge of the universe.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew1', bv: 'Director', aw: 'Ava DuVernay', aI: $elm$core$Maybe$Nothing},
						{bk: 'Production', E: 'crew2', bv: 'Executive Producer', aw: 'Christopher Nolan', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Drama', 'Mystery']),
				E: 'show2',
				aG: 'show2.jpg',
				aJ: 8.7,
				aP: 'Chronicles of the Void',
				aQ: 1,
				aS: 2021
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. Alex Harper', E: 'cast4', aw: 'Ryan Gosling', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Commander Maya Zhou', E: 'cast5', aw: 'Lupita Nyong\'o', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('When a team of scientists discovers a habitable planet at the edge of a distant nebula, they embark on a perilous journey only to find they are not alone.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew3', bv: 'Director', aw: 'Denis Villeneuve', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Adventure', 'Horror']),
				E: 'movie4',
				aG: 'movie4.jpg',
				aJ: 7.5,
				aP: 'Nebula\'s Edge',
				aQ: 0,
				aS: 2024
			}
			]),
		aw: 'Continue Watching'
	},
		{
		E: 'recently-added',
		cu: _List_fromArray(
			[
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. James Wilson', E: 'cast6', aw: 'Daniel Kaluuya', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Agent Elizabeth Bennett', E: 'cast7', aw: 'Florence Pugh', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('When a brilliant physicist discovers a way to manipulate time using quantum mechanics, governments and corporations race to control the technology.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew4', bv: 'Director', aw: 'Bong Joon-ho', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Thriller', 'Drama']),
				E: 'movie1',
				aG: 'movie1.jpg',
				aJ: 8.5,
				aP: 'The Quantum Protocol',
				aQ: 0,
				aS: 2023
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Memory Detective Eliza Grey', E: 'cast8', aw: 'Saoirse Ronan', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Hacker Leo Chen', E: 'cast9', aw: 'Rami Malek', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('In a future where memories can be shared digitally, a memory detective uncovers a conspiracy that threatens global stability.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew5', bv: 'Director', aw: 'Chloe Zhao', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Mystery', 'Thriller']),
				E: 'movie2',
				aG: 'movie2.jpg',
				aJ: 7.8,
				aP: 'Echoes of Tomorrow',
				aQ: 0,
				aS: 2024
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Various Characters', E: 'cast10', aw: 'Anya Taylor-Joy', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Various Characters', E: 'cast11', aw: 'Anthony Mackie', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('An anthology series exploring the intersection of technology and humanity across different possible futures.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew6', bv: 'Creator', aw: 'Lana Wachowski', aI: $elm$core$Maybe$Nothing},
						{bk: 'Directing', E: 'crew7', bv: 'Director', aw: 'Alex Garland', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Drama', 'Anthology']),
				E: 'show1',
				aG: 'show1.jpg',
				aJ: 9.2,
				aP: 'Digital Horizons',
				aQ: 1,
				aS: 2023
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Commander Thomas Rivera', E: 'cast12', aw: 'Oscar Isaac', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Dr. Maya Patel', E: 'cast13', aw: 'Tessa Thompson', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('The first human colony on Mars faces unexpected challenges when strange artifacts are discovered beneath the planet\'s surface.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew8', bv: 'Director', aw: 'James Gray', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Adventure']),
				E: 'movie3',
				aG: 'movie3.jpg',
				aJ: 6.9,
				aP: 'Stellar Odyssey',
				aQ: 0,
				aS: 2022
			}
			]),
		aw: 'Recently Added'
	},
		{
		E: 'recommended',
		cu: _List_fromArray(
			[
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Commander Jack Harding', E: 'cast14', aw: 'Keanu Reeves', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Astrophysicist Dr. Olivia Chen', E: 'cast15', aw: 'Zendaya', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('As a nearby star threatens to go supernova, a specialized team of astronauts must embark on a mission to prevent catastrophe on Earth.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew9', bv: 'Director', aw: 'Patty Jenkins', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Action', 'Drama']),
				E: 'movie5',
				aG: 'movie5.jpg',
				aJ: 9.1,
				aP: 'Hypernova',
				aQ: 0,
				aS: 2023
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. Elijah Cross', E: 'cast16', aw: 'Jonathan Majors', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Timeline Investigator Kate Wilson', E: 'cast17', aw: 'Jodie Comer', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('After a particle accelerator experiment goes wrong, reality splits into multiple timelines that begin to collide with devastating consequences.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew10', bv: 'Creator', aw: 'Noah Hawley', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Mystery', 'Drama']),
				E: 'show3',
				aG: 'show3.jpg',
				aJ: 8.4,
				aP: 'Temporal Divide',
				aQ: 1,
				aS: 2022
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Emma/Alternate Emma', E: 'cast18', aw: 'Brie Larson', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Dr. Marcus Shaw', E: 'cast19', aw: 'LaKeith Stanfield', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A woman discovers her doppelgänger from a parallel universe, leading to an identity crisis as she questions which reality is truly her own.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew11', bv: 'Director', aw: 'Darren Aronofsky', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Psychological', 'Drama']),
				E: 'movie6',
				aG: 'movie6.jpg',
				aJ: 7.2,
				aP: 'Parallel Essence',
				aQ: 0,
				aS: 2024
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. Robert Chen', E: 'cast20', aw: 'John David Washington', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Commander Diana Jackson', E: 'cast21', aw: 'Cynthia Erivo', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A team of scientists working on quantum computing inadvertently open a gateway to alternate dimensions, unleashing chaos across the multiverse.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew12', bv: 'Creators', aw: 'The Wachowskis', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Adventure', 'Action']),
				E: 'show4',
				aG: 'show4.jpg',
				aJ: 8.9,
				aP: 'Quantum Nexus',
				aQ: 1,
				aS: 2021
			}
			]),
		aw: 'Recommended For You'
	}
	]);
var $author$project$MockData$mockLibraryCategories = _List_fromArray(
	[
		{
		E: 'movie-library',
		cu: _List_fromArray(
			[
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Voice of IRIS AI', E: 'cast22', aw: 'Steven Yeun', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Dr. Samantha Liu', E: 'cast23', aw: 'Thomasin McKenzie', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A philosophical journey through the cosmos as an AI aboard an interstellar vessel contemplates the nature of existence.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew13', bv: 'Director', aw: 'Richard Linklater', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Drama', 'Philosophy']),
				E: 'movie7',
				aG: 'movie7.jpg',
				aJ: 8.3,
				aP: 'Cosmic Paradigm',
				aQ: 0,
				aS: 2023
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Ethan Reed', E: 'cast24', aw: 'Paul Mescal', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Lily Chen', E: 'cast25', aw: 'Daisy Edgar-Jones', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('Two strangers discover they share dreams and thoughts through an unexplained neural connection, leading them on a journey to find each other.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew14', bv: 'Director', aw: 'Greta Gerwig', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Romance', 'Mystery']),
				E: 'movie8',
				aG: 'movie8.jpg',
				aJ: 7.9,
				aP: 'Neural Connection',
				aQ: 0,
				aS: 2024
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dream Detective Elias Cross', E: 'cast26', aw: 'Mahershala Ali', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Senator Victoria Palmer', E: 'cast27', aw: 'Rebecca Ferguson', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('In a world where dreams can be recorded and sold as entertainment, a dream detective investigates the theft of a prominent politician\'s subconscious.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew15', bv: 'Director', aw: 'Rian Johnson', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Neo-Noir', 'Mystery']),
				E: 'movie9',
				aG: 'movie9.jpg',
				aJ: 8.1,
				aP: 'Synthetic Dreams',
				aQ: 0,
				aS: 2022
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Data Archaeologist Max Rivera', E: 'cast28', aw: 'Pedro Pascal', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'AI Specialist Dr. Amara Johnson', E: 'cast29', aw: 'Letitia Wright', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A team of data archaeologists explore the ruins of the Internet after a global cyber-catastrophe, discovering secrets that were meant to stay buried.'),
				aE: _List_fromArray(
					[
						{bk: 'Directing', E: 'crew16', bv: 'Director', aw: 'Taika Waititi', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Adventure', 'Mystery']),
				E: 'movie10',
				aG: 'movie10.jpg',
				aJ: 7.6,
				aP: 'Digital Frontier',
				aQ: 0,
				aS: 2023
			}
			]),
		aw: 'Movies'
	},
		{
		E: 'tv-library',
		cu: _List_fromArray(
			[
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. Lucy Chen', E: 'cast30', aw: 'Gemma Chan', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'General Marcus Williams', E: 'cast31', aw: 'David Oyelowo', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('Humanity makes first contact with an alien intelligence that communicates through manipulating the fabric of reality itself.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew17', bv: 'Creator', aw: 'Denis Villeneuve', aI: $elm$core$Maybe$Nothing},
						{bk: 'Directing', E: 'crew18', bv: 'Director', aw: 'Nia DaCosta', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Drama', 'Mystery']),
				E: 'show5',
				aG: 'show5.jpg',
				aJ: 8.8,
				aP: 'Ethereal Connection',
				aQ: 1,
				aS: 2022
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Agent Thomas Blake', E: 'cast32', aw: 'Daniel Craig', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Director Nora Ellis', E: 'cast33', aw: 'Janelle Monáe', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('A secret government agency monitors timeline alterations and sends agents to prevent catastrophic changes to history.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew19', bv: 'Creator', aw: 'Jonathan Nolan', aI: $elm$core$Maybe$Nothing},
						{bk: 'Production', E: 'crew20', bv: 'Creator', aw: 'Lisa Joy', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Action', 'History']),
				E: 'show6',
				aG: 'show6.jpg',
				aJ: 9.0,
				aP: 'Parallel Futures',
				aQ: 1,
				aS: 2023
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Dr. Violet Chen', E: 'cast34', aw: 'Sonoya Mizuno', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'FBI Agent Marcus Hill', E: 'cast35', aw: 'Aldis Hodge', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('After a particle accelerator accident, a physicist gains the ability to see and interact with quantum probability waves, allowing her to perceive possible futures.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew21', bv: 'Creator', aw: 'Sam Esmail', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Drama', 'Thriller']),
				E: 'show7',
				aG: 'show7.jpg',
				aJ: 8.2,
				aP: 'Quantum Horizon',
				aQ: 1,
				aS: 2024
			},
				{
				bc: $elm$core$Maybe$Nothing,
				be: _List_fromArray(
					[
						{bg: 'Detective James Park', E: 'cast36', aw: 'John Cho', bF: 0, aI: $elm$core$Maybe$Nothing},
						{bg: 'Dr. Eliza Ward', E: 'cast37', aw: 'Thandiwe Newton', bF: 1, aI: $elm$core$Maybe$Nothing}
					]),
				aD: $elm$core$Maybe$Just('In a near future where human minds can connect to a shared digital consciousness, a detective investigates murders taking place both in reality and the virtual world.'),
				aE: _List_fromArray(
					[
						{bk: 'Production', E: 'crew22', bv: 'Creator', aw: 'Lilly Wachowski', aI: $elm$core$Maybe$Nothing}
					]),
				as: _List_fromArray(
					['Sci-Fi', 'Crime', 'Cyberpunk']),
				E: 'show8',
				aG: 'show8.jpg',
				aJ: 7.7,
				aP: 'Neural Network',
				aQ: 1,
				aS: 2021
			}
			]),
		aw: 'TV Shows'
	}
	]);
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $elm$core$Basics$not = _Basics_not;
var $elm$core$List$sortBy = _List_sortBy;
var $elm$core$List$sort = function (xs) {
	return A2($elm$core$List$sortBy, $elm$core$Basics$identity, xs);
};
var $author$project$MediaDetail$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 0:
				var mediaId = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{T: $elm$core$Maybe$Nothing, J: true}),
					$elm$core$Platform$Cmd$none);
			case 1:
				var result = msg.a;
				if (!result.$) {
					var detail = result.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								T: $elm$core$Maybe$Nothing,
								J: false,
								av: $elm$core$Maybe$Just(detail)
							}),
						$elm$core$Platform$Cmd$none);
				} else {
					var error = result.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								T: $elm$core$Maybe$Just(error),
								J: false
							}),
						$elm$core$Platform$Cmd$none);
				}
			case 2:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{T: $elm$core$Maybe$Nothing, av: $elm$core$Maybe$Nothing}),
					$elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$ServerSettings$ConnectionTested = function (a) {
	return {$: 6, a: a};
};
var $author$project$ServerSettings$Success = {$: 0};
var $author$project$ServerSettings$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 0:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ag: !model.ag}),
					$elm$core$Platform$Cmd$none);
			case 1:
				var value = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aa: value}),
					$elm$core$Platform$Cmd$none);
			case 2:
				var value = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{Q: value}),
					$elm$core$Platform$Cmd$none);
			case 3:
				var value = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{Z: value}),
					$elm$core$Platform$Cmd$none);
			case 4:
				var newConfig = {
					aU: $elm$core$String$isEmpty(model.Q) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(model.Q),
					aV: model.aa,
					a8: $elm$core$String$isEmpty(model.Z) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(model.Z)
				};
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{S: $elm$core$Maybe$Nothing, ag: false, a2: newConfig}),
					$elm$core$Platform$Cmd$none);
			case 5:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{S: $elm$core$Maybe$Nothing, af: true}),
					A2(
						$elm$core$Task$perform,
						$elm$core$Basics$identity,
						$elm$core$Task$succeed(
							$author$project$ServerSettings$ConnectionTested($author$project$ServerSettings$Success))));
			case 6:
				var status = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							S: $elm$core$Maybe$Just(status),
							af: false
						}),
					$elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							Q: A2($elm$core$Maybe$withDefault, '', $author$project$JellyfinAPI$defaultServerConfig.aU),
							aa: $author$project$JellyfinAPI$defaultServerConfig.aV,
							S: $elm$core$Maybe$Nothing,
							Z: A2($elm$core$Maybe$withDefault, '', $author$project$JellyfinAPI$defaultServerConfig.a8)
						}),
					$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$JellyfinUI$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 21:
				var width = msg.a;
				var height = msg.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{x: width}),
					$elm$core$Platform$Cmd$none);
			case 0:
				var query = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aj: query}),
					$elm$core$Platform$Cmd$none);
			case 1:
				var categoryId = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							ay: $elm$core$Maybe$Just(categoryId)
						}),
					$elm$core$Platform$Cmd$none);
			case 2:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ay: $elm$core$Maybe$Nothing}),
					$elm$core$Platform$Cmd$none);
			case 3:
				var mediaId = msg.a;
				var foundItem = $elm$core$List$head(
					A2(
						$elm$core$List$filter,
						function (item) {
							return _Utils_eq(item.E, mediaId);
						},
						A2(
							$elm$core$List$concatMap,
							function ($) {
								return $.cu;
							},
							model.u)));
				var detailCmd = function () {
					if (!foundItem.$) {
						var item = foundItem.a;
						var duration = 120;
						var description = A2($elm$core$Maybe$withDefault, 'No description available.', item.aD);
						var detail = $elm$core$Result$Ok(
							{aT: item.be, aD: description, aE: item.aE, aX: duration, as: item.as, E: item.E, aG: item.aG, aJ: item.aJ, aP: item.aP, aQ: item.aQ, aS: item.aS});
						return function (cmd) {
							return A2(
								$elm$core$Task$perform,
								$elm$core$Basics$identity,
								$elm$core$Task$succeed(cmd));
						}(
							$author$project$JellyfinUI$MediaDetailMsg(
								$author$project$MediaDetail$MediaDetailReceived(detail)));
					} else {
						return function (cmd) {
							return A2(
								$elm$core$Task$perform,
								$elm$core$Basics$identity,
								$elm$core$Task$succeed(cmd));
						}(
							$author$project$JellyfinUI$MediaDetailMsg(
								$author$project$MediaDetail$MediaDetailReceived(
									$elm$core$Result$Err('Media item not found'))));
					}
				}();
				return _Utils_Tuple2(model, detailCmd);
			case 4:
				var mediaId = msg.a;
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 5:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{J: true}),
					$author$project$TMDBData$fetchTMDBData($author$project$JellyfinUI$TMDBDataReceived));
			case 6:
				var categories = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{u: categories, J: false}),
					$elm$core$Platform$Cmd$none);
			case 7:
				var subMsg = msg.a;
				var _v2 = A2($author$project$MediaDetail$update, subMsg, model.ai);
				var updatedMediaDetailModel = _v2.a;
				var mediaDetailCmd = _v2.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ai: updatedMediaDetailModel}),
					A2($elm$core$Platform$Cmd$map, $author$project$JellyfinUI$MediaDetailMsg, mediaDetailCmd));
			case 8:
				var subMsg = msg.a;
				var _v3 = A2($author$project$ServerSettings$update, subMsg, model.aN);
				var updatedServerSettingsModel = _v3.a;
				var serverSettingsCmd = _v3.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aN: updatedServerSettingsModel}),
					A2($elm$core$Platform$Cmd$map, $author$project$JellyfinUI$ServerSettingsMsg, serverSettingsCmd));
			case 9:
				var newConfig = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{a2: newConfig}),
					$elm$core$Platform$Cmd$none);
			case 10:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{I: false, K: false, L: !model.L}),
					$elm$core$Platform$Cmd$none);
			case 12:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{I: !model.I, K: false, L: false}),
					$elm$core$Platform$Cmd$none);
			case 13:
				var genre = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							I: false,
							B: $elm$core$Maybe$Just(genre)
						}),
					$elm$core$Platform$Cmd$none);
			case 14:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{B: $elm$core$Maybe$Nothing}),
					$elm$core$Platform$Cmd$none);
			case 15:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{I: false, K: !model.K, L: false}),
					$elm$core$Platform$Cmd$none);
			case 16:
				var mediaType = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							K: false,
							C: $elm$core$Maybe$Just(mediaType)
						}),
					$elm$core$Platform$Cmd$none);
			case 17:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{C: $elm$core$Maybe$Nothing}),
					$elm$core$Platform$Cmd$none);
			case 11:
				var action = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{L: false}),
					$elm$core$Platform$Cmd$none);
			case 18:
				var categoryId = msg.a;
				var direction = msg.b;
				var scrollAmount = 300.0;
				var maybeCategory = A2($author$project$JellyfinUI$findCategory, categoryId, model.u);
				var maxScrollPosition = function () {
					if (!maybeCategory.$) {
						var category = maybeCategory.a;
						var itemsCount = $elm$core$List$length(category.cu);
						var itemSize = 200.0;
						var displayCount = (model.x > 1600) ? 5.0 : ((model.x > 1200) ? 4.0 : ((model.x > 900) ? 3.0 : ((model.x > 600) ? 2.0 : 1.0)));
						var contentSize = itemsCount * itemSize;
						var containerSize = displayCount * itemSize;
						return (_Utils_cmp(itemsCount, displayCount) < 1) ? 0.0 : (-(contentSize - containerSize));
					} else {
						return 0.0;
					}
				}();
				var currentTranslation = A2(
					$elm$core$Maybe$withDefault,
					0,
					A2($elm$core$Dict$get, categoryId, model.ab));
				var newTranslation = (direction > 0) ? A2($elm$core$Basics$max, maxScrollPosition, currentTranslation - scrollAmount) : A2($elm$core$Basics$min, 0.0, currentTranslation + scrollAmount);
				var updatedTranslations = A3($elm$core$Dict$insert, categoryId, newTranslation, model.ab);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ab: updatedTranslations}),
					$elm$core$Platform$Cmd$none);
			case 19:
				var result = msg.a;
				if (!result.$) {
					var tmdbData = result.a;
					var allGenres = A3(
						$elm$core$List$foldl,
						F2(
							function (genre, acc) {
								return A2($elm$core$List$member, genre, acc) ? acc : A2($elm$core$List$cons, genre, acc);
							}),
						_List_Nil,
						$elm$core$List$sort(
							A2(
								$elm$core$List$concatMap,
								function ($) {
									return $.as;
								},
								A2(
									$elm$core$List$concatMap,
									function ($) {
										return $.cu;
									},
									tmdbData.u))));
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								aq: $elm$core$List$isEmpty(allGenres) ? model.aq : allGenres,
								u: tmdbData.u,
								ad: $elm$core$Maybe$Nothing,
								J: false
							}),
						$elm$core$Platform$Cmd$none);
				} else {
					var error = result.a;
					var errorMsg = function () {
						switch (error.$) {
							case 0:
								var url = error.a;
								return 'Bad URL: ' + url;
							case 1:
								return 'Request timed out';
							case 2:
								return 'Network error - check your connection';
							case 3:
								var status = error.a;
								return 'Bad status: ' + $elm$core$String$fromInt(status);
							default:
								var message = error.a;
								return 'Data parsing error: ' + message;
						}
					}();
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								u: _Utils_ap($author$project$MockData$mockCategories, $author$project$MockData$mockLibraryCategories),
								ad: $elm$core$Maybe$Just(errorMsg),
								J: false
							}),
						$elm$core$Platform$Cmd$none);
				}
			case 20:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ad: $elm$core$Maybe$Nothing, J: true}),
					$author$project$TMDBData$fetchTMDBData($author$project$JellyfinUI$TMDBDataReceived));
			default:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		var jellyfinMsg = msg;
		var _v1 = A2($author$project$JellyfinUI$update, jellyfinMsg, model.ah);
		var updatedJellyfinModel = _v1.a;
		var jellyfinCmd = _v1.b;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{ah: updatedJellyfinModel}),
			A2($elm$core$Platform$Cmd$map, $elm$core$Basics$identity, jellyfinCmd));
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var $elm$html$Html$map = $elm$virtual_dom$VirtualDom$map;
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $author$project$Theme$Body = 3;
var $author$project$MediaDetail$CloseDetail = {$: 2};
var $author$project$Theme$Heading2 = 1;
var $author$project$Theme$Primary = 0;
var $elm$html$Html$button = _VirtualDom_node('button');
var $author$project$Theme$button = function (style) {
	var baseClasses = 'font-medium py-1 px-3 rounded transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-opacity-50 text-sm';
	switch (style) {
		case 0:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-primary hover:bg-primary-dark text-text-primary focus:ring-primary-light')
				]);
		case 1:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-secondary hover:bg-secondary-dark text-background focus:ring-secondary-light')
				]);
		case 2:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-success hover:bg-success-dark text-background focus:ring-success-light')
				]);
		case 3:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-warning hover:bg-warning-dark text-background-dark focus:ring-warning-light')
				]);
		case 4:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-error hover:bg-error-dark text-text-primary focus:ring-error-light')
				]);
		default:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class(baseClasses + ' bg-transparent hover:bg-surface-light text-text-primary border border-surface-light focus:ring-primary')
				]);
	}
};
var $elm$html$Html$h2 = _VirtualDom_node('h2');
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 0, a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$html$Html$p = _VirtualDom_node('p');
var $author$project$Theme$text = function (style) {
	switch (style) {
		case 0:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-3xl font-bold text-text-primary text-glow')
				]);
		case 1:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-2xl font-semibold text-text-primary')
				]);
		case 2:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-xl font-semibold text-primary')
				]);
		case 3:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-sm text-text-primary')
				]);
		case 4:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-xs text-text-secondary')
				]);
		case 5:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-xs font-medium text-info')
				]);
		default:
			return _List_fromArray(
				[
					$elm$html$Html$Attributes$class('font-mono text-xs text-text-primary bg-background-light px-1 py-0.5 rounded')
				]);
	}
};
var $author$project$MediaDetail$viewError = function (errorMsg) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('bg-surface p-4 rounded-lg max-w-lg w-full')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h2,
						_Utils_ap(
							$author$project$Theme$text(1),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-error')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text('Error')
							])),
						A2(
						$elm$html$Html$p,
						_Utils_ap(
							$author$project$Theme$text(3),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('my-3')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(errorMsg)
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex justify-end')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_Utils_ap(
									$author$project$Theme$button(0),
									_List_fromArray(
										[
											$elm$html$Html$Events$onClick($author$project$MediaDetail$CloseDetail)
										])),
								_List_fromArray(
									[
										$elm$html$Html$text('Close')
									]))
							]))
					]))
			]));
};
var $author$project$MediaDetail$viewLoading = A2(
	$elm$html$Html$div,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$class('fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50')
		]),
	_List_fromArray(
		[
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-primary text-lg')
				]),
			_List_fromArray(
				[
					$elm$html$Html$text('Loading...')
				]))
		]));
var $author$project$Theme$Caption = 4;
var $author$project$Theme$Ghost = 5;
var $author$project$Theme$Heading1 = 0;
var $author$project$Theme$Label = 5;
var $author$project$MediaDetail$PlayMedia = function (a) {
	return {$: 3, a: a};
};
var $elm$core$Basics$modBy = _Basics_modBy;
var $author$project$MediaDetail$formatDuration = function (minutes) {
	var mins = A2($elm$core$Basics$modBy, 60, minutes);
	var hours = (minutes / 60) | 0;
	return (hours > 0) ? ($elm$core$String$fromInt(hours) + ('h ' + ($elm$core$String$fromInt(mins) + 'm'))) : ($elm$core$String$fromInt(mins) + 'm');
};
var $elm$core$String$fromFloat = _String_fromNumber;
var $elm$html$Html$h1 = _VirtualDom_node('h1');
var $elm$html$Html$h3 = _VirtualDom_node('h3');
var $author$project$MediaDetail$mediaTypeToString = function (mediaType) {
	switch (mediaType) {
		case 0:
			return 'Movie';
		case 1:
			return 'TV Show';
		default:
			return 'Music';
	}
};
var $elm$html$Html$span = _VirtualDom_node('span');
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $elm$html$Html$Attributes$alt = $elm$html$Html$Attributes$stringProperty('alt');
var $elm$html$Html$img = _VirtualDom_node('img');
var $elm$html$Html$Attributes$src = function (url) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'src',
		_VirtualDom_noJavaScriptOrHtmlUri(url));
};
var $author$project$MediaDetail$viewCastMember = function (cast) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex items-center space-x-1')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('w-8 h-8 rounded-full bg-background-light flex items-center justify-center text-xs overflow-hidden')
					]),
				_List_fromArray(
					[
						function () {
						var _v0 = cast.aI;
						if (!_v0.$) {
							var url = _v0.a;
							return A2(
								$elm$html$Html$img,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$src(url),
										$elm$html$Html$Attributes$alt(cast.aw),
										$elm$html$Html$Attributes$class('w-full h-full object-cover')
									]),
								_List_Nil);
						} else {
							return $elm$html$Html$text(
								A2($elm$core$String$left, 1, cast.aw));
						}
					}()
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex flex-col')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$span,
						_Utils_ap(
							$author$project$Theme$text(3),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-sm')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(cast.aw)
							])),
						A2(
						$elm$html$Html$span,
						_Utils_ap(
							$author$project$Theme$text(4),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-xs text-text-secondary')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(cast.bg)
							]))
					]))
			]));
};
var $author$project$MediaDetail$viewCrewMember = function (crew) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex items-center space-x-1')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('w-7 h-7 rounded-full bg-background-light flex items-center justify-center text-xs overflow-hidden')
					]),
				_List_fromArray(
					[
						function () {
						var _v0 = crew.aI;
						if (!_v0.$) {
							var url = _v0.a;
							return A2(
								$elm$html$Html$img,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$src(url),
										$elm$html$Html$Attributes$alt(crew.aw),
										$elm$html$Html$Attributes$class('w-full h-full object-cover')
									]),
								_List_Nil);
						} else {
							return $elm$html$Html$text(
								A2($elm$core$String$left, 1, crew.aw));
						}
					}()
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex flex-col')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$span,
						_Utils_ap(
							$author$project$Theme$text(3),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-sm')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(crew.aw)
							])),
						A2(
						$elm$html$Html$span,
						_Utils_ap(
							$author$project$Theme$text(4),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-xs text-text-secondary')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(crew.bv)
							]))
					]))
			]));
};
var $author$project$MediaDetail$viewGenre = function (genre) {
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('bg-background-light px-2 py-0.5 rounded text-text-secondary text-xs')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(genre)
			]));
};
var $author$project$MediaDetail$viewMediaDetail = function (detail) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50 p-2 overflow-y-auto')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('bg-surface rounded-lg max-w-4xl w-full shadow-lg relative')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute top-2 right-2 text-text-secondary hover:text-text-primary'),
								$elm$html$Html$Events$onClick($author$project$MediaDetail$CloseDetail)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('✕')
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('md:flex')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('md:w-1/3 p-3')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('relative pt-[150%] bg-background-light rounded-md')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$div,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$class('absolute inset-0'),
														A2($elm$html$Html$Attributes$style, 'background-image', 'linear-gradient(rgba(28, 28, 28, 0.2), rgba(28, 28, 28, 0.8))')
													]),
												_List_Nil)
											])),
										A2(
										$elm$html$Html$button,
										_Utils_ap(
											$author$project$Theme$button(0),
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('w-full mt-2'),
													$elm$html$Html$Events$onClick(
													$author$project$MediaDetail$PlayMedia(detail.E))
												])),
										_List_fromArray(
											[
												$elm$html$Html$text('Play')
											])),
										(detail.aQ === 1) ? A2(
										$elm$html$Html$button,
										_Utils_ap(
											$author$project$Theme$button(5),
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('w-full mt-1')
												])),
										_List_fromArray(
											[
												$elm$html$Html$text('View Episodes')
											])) : $elm$html$Html$text('')
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('md:w-2/3 p-3')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$h1,
										$author$project$Theme$text(0),
										_List_fromArray(
											[
												$elm$html$Html$text(detail.aP)
											])),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('flex flex-wrap items-center space-x-1 mt-1')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$span,
												$author$project$Theme$text(4),
												_List_fromArray(
													[
														$elm$html$Html$text(
														$elm$core$String$fromInt(detail.aS))
													])),
												A2(
												$elm$html$Html$span,
												$author$project$Theme$text(4),
												_List_fromArray(
													[
														$elm$html$Html$text('•')
													])),
												A2(
												$elm$html$Html$span,
												$author$project$Theme$text(4),
												_List_fromArray(
													[
														$elm$html$Html$text(
														$author$project$MediaDetail$mediaTypeToString(detail.aQ))
													])),
												A2(
												$elm$html$Html$span,
												$author$project$Theme$text(4),
												_List_fromArray(
													[
														$elm$html$Html$text('•')
													])),
												A2(
												$elm$html$Html$span,
												$author$project$Theme$text(4),
												_List_fromArray(
													[
														$elm$html$Html$text(
														$author$project$MediaDetail$formatDuration(detail.aX))
													])),
												A2(
												$elm$html$Html$span,
												_Utils_ap(
													$author$project$Theme$text(4),
													_List_fromArray(
														[
															$elm$html$Html$Attributes$class('text-warning')
														])),
												_List_fromArray(
													[
														$elm$html$Html$text(
														'★ ' + $elm$core$String$fromFloat(detail.aJ))
													]))
											])),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('mt-2')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$h3,
												$author$project$Theme$text(5),
												_List_fromArray(
													[
														$elm$html$Html$text('Genres')
													])),
												A2(
												$elm$html$Html$div,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$class('flex flex-wrap gap-1 mt-1')
													]),
												A2($elm$core$List$map, $author$project$MediaDetail$viewGenre, detail.as))
											])),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('mt-2')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$h3,
												$author$project$Theme$text(5),
												_List_fromArray(
													[
														$elm$html$Html$text('Overview')
													])),
												A2(
												$elm$html$Html$p,
												_Utils_ap(
													$author$project$Theme$text(3),
													_List_fromArray(
														[
															$elm$html$Html$Attributes$class('mt-1')
														])),
												_List_fromArray(
													[
														$elm$html$Html$text(detail.aD)
													]))
											])),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('mt-2')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$h3,
												$author$project$Theme$text(5),
												_List_fromArray(
													[
														$elm$html$Html$text('Cast')
													])),
												A2(
												$elm$html$Html$div,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$class('grid grid-cols-2 gap-1 mt-1')
													]),
												A2(
													$elm$core$List$take,
													6,
													A2($elm$core$List$map, $author$project$MediaDetail$viewCastMember, detail.aT)))
											])),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('mt-2')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$h3,
												$author$project$Theme$text(5),
												_List_fromArray(
													[
														$elm$html$Html$text('Directors')
													])),
												A2(
												$elm$html$Html$div,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$class('flex flex-wrap gap-1 mt-1')
													]),
												A2($elm$core$List$map, $author$project$MediaDetail$viewCrewMember, detail.aE))
											]))
									]))
							]))
					]))
			]));
};
var $author$project$MediaDetail$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				function () {
				if (model.J) {
					return $author$project$MediaDetail$viewLoading;
				} else {
					var _v0 = model.av;
					if (!_v0.$) {
						var detail = _v0.a;
						return $author$project$MediaDetail$viewMediaDetail(detail);
					} else {
						var _v1 = model.T;
						if (!_v1.$) {
							var errorMsg = _v1.a;
							return $author$project$MediaDetail$viewError(errorMsg);
						} else {
							return $elm$html$Html$text('');
						}
					}
				}
			}()
			]));
};
var $elm$core$Basics$neq = _Utils_notEqual;
var $author$project$JellyfinUI$ClearGenreFilter = {$: 14};
var $author$project$JellyfinUI$viewActiveFilter = function (maybeGenre) {
	if (!maybeGenre.$) {
		var genre = maybeGenre.a;
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center bg-primary bg-opacity-20 border border-primary rounded-full px-2 py-0.5')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$span,
					$author$project$Theme$text(3),
					_List_fromArray(
						[
							$elm$html$Html$text(genre)
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('ml-1 text-primary hover:text-primary-dark'),
							$elm$html$Html$Events$onClick($author$project$JellyfinUI$ClearGenreFilter)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('×')
						]))
				]));
	} else {
		return $elm$html$Html$text('');
	}
};
var $author$project$JellyfinUI$ClearTypeFilter = {$: 17};
var $author$project$JellyfinUI$mediaTypeToString = function (mediaType) {
	switch (mediaType) {
		case 0:
			return 'Movie';
		case 1:
			return 'TV Show';
		default:
			return 'Music';
	}
};
var $author$project$JellyfinUI$viewActiveTypeFilter = function (maybeType) {
	if (!maybeType.$) {
		var mediaType = maybeType.a;
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center bg-secondary bg-opacity-20 border border-secondary rounded-full px-2 py-0.5')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$span,
					$author$project$Theme$text(3),
					_List_fromArray(
						[
							$elm$html$Html$text(
							$author$project$JellyfinUI$mediaTypeToString(mediaType))
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('ml-1 text-secondary hover:text-secondary-dark'),
							$elm$html$Html$Events$onClick($author$project$JellyfinUI$ClearTypeFilter)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('×')
						]))
				]));
	} else {
		return $elm$html$Html$text('');
	}
};
var $elm$core$String$toLower = _String_toLower;
var $author$project$JellyfinUI$filterCategories = F2(
	function (query, categories) {
		return $elm$core$String$isEmpty(query) ? categories : A2(
			$elm$core$List$filter,
			function (category) {
				return !$elm$core$List$isEmpty(category.cu);
			},
			A2(
				$elm$core$List$map,
				function (category) {
					return _Utils_update(
						category,
						{
							cu: A2(
								$elm$core$List$filter,
								function (item) {
									return A2(
										$elm$core$String$contains,
										$elm$core$String$toLower(query),
										$elm$core$String$toLower(item.aP));
								},
								category.cu)
						});
				},
				categories));
	});
var $author$project$JellyfinUI$itemHasGenre = F2(
	function (genre, item) {
		return A2($elm$core$List$member, genre, item.as);
	});
var $author$project$JellyfinUI$filterCategoriesByGenre = F2(
	function (maybeGenre, categories) {
		if (maybeGenre.$ === 1) {
			return categories;
		} else {
			var genre = maybeGenre.a;
			return A2(
				$elm$core$List$filter,
				function (category) {
					return !$elm$core$List$isEmpty(category.cu);
				},
				A2(
					$elm$core$List$map,
					function (category) {
						return _Utils_update(
							category,
							{
								cu: A2(
									$elm$core$List$filter,
									$author$project$JellyfinUI$itemHasGenre(genre),
									category.cu)
							});
					},
					categories));
		}
	});
var $author$project$JellyfinUI$filterCategoriesByType = F2(
	function (maybeType, categories) {
		if (maybeType.$ === 1) {
			return categories;
		} else {
			var mediaType = maybeType.a;
			return A2(
				$elm$core$List$filter,
				function (category) {
					return !$elm$core$List$isEmpty(category.cu);
				},
				A2(
					$elm$core$List$map,
					function (category) {
						return _Utils_update(
							category,
							{
								cu: A2(
									$elm$core$List$filter,
									function (item) {
										return _Utils_eq(item.aQ, mediaType);
									},
									category.cu)
							});
					},
					categories));
		}
	});
var $author$project$Theme$Heading3 = 2;
var $author$project$JellyfinUI$NoOp = {$: 22};
var $author$project$JellyfinUI$ScrollCategory = F2(
	function (a, b) {
		return {$: 18, a: a, b: b};
	});
var $author$project$JellyfinUI$SelectCategory = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Basics$ge = _Utils_ge;
var $author$project$JellyfinUI$PlayMedia = function (a) {
	return {$: 4, a: a};
};
var $author$project$JellyfinUI$SelectMediaItem = function (a) {
	return {$: 3, a: a};
};
var $elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $elm$html$Html$Attributes$attribute = $elm$virtual_dom$VirtualDom$attribute;
var $author$project$JellyfinUI$viewMediaItem = function (item) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary cursor-pointer h-full group transform hover:scale-105'),
				A2($elm$html$Html$Attributes$style, 'transition', 'all 0.3s cubic-bezier(0.25, 0.1, 0.25, 1.0)'),
				A2($elm$html$Html$Attributes$style, 'will-change', 'transform, box-shadow, border-color'),
				$elm$html$Html$Events$onClick(
				$author$project$JellyfinUI$SelectMediaItem(item.E))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('relative pt-[150%]')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$img,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$src(item.aG),
								$elm$html$Html$Attributes$class('absolute inset-0 w-full h-full object-cover transition-all duration-300 group-hover:brightness-110'),
								$elm$html$Html$Attributes$alt(item.aP),
								A2($elm$html$Html$Attributes$attribute, 'onerror', 'this.style.display=\'none\'; this.nextElementSibling.style.display=\'flex\';')
							]),
						_List_Nil),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute inset-0 flex items-center justify-center bg-background-light text-primary-light'),
								A2($elm$html$Html$Attributes$style, 'display', 'none')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('🎬')
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute inset-0 flex items-center justify-center z-30')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 cursor-pointer hover:scale-110 bg-transparent relative z-40'),
										$elm$html$Html$Events$onClick(
										$author$project$JellyfinUI$PlayMedia(item.E)),
										A2($elm$html$Html$Attributes$attribute, 'data-testid', 'play-button')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$span,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('text-2xl font-bold text-white'),
												A2($elm$html$Html$Attributes$style, 'filter', 'drop-shadow(0 0 10px rgba(127, 168, 204, 1)) drop-shadow(0 0 20px rgba(95, 135, 175, 0.9)) drop-shadow(0 0 30px rgba(95, 135, 175, 0.7))'),
												A2($elm$html$Html$Attributes$style, 'position', 'relative'),
												A2($elm$html$Html$Attributes$style, 'z-index', '50')
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('▶')
											]))
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-background-dark via-transparent to-transparent opacity-90 text-text-primary p-3 transition-all duration-300')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$h3,
								_Utils_ap(
									$author$project$Theme$text(2),
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('truncate text-white')
										])),
								_List_fromArray(
									[
										$elm$html$Html$text(item.aP)
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex justify-between items-center mt-1')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$span,
										$author$project$Theme$text(4),
										_List_fromArray(
											[
												$elm$html$Html$text(
												$elm$core$String$fromInt(item.aS))
											])),
										A2(
										$elm$html$Html$span,
										_Utils_ap(
											$author$project$Theme$text(4),
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('text-warning')
												])),
										_List_fromArray(
											[
												$elm$html$Html$text(
												'★ ' + $elm$core$String$fromFloat(item.aJ))
											]))
									])),
								($elm$core$List$length(item.as) > 0) ? A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex flex-wrap gap-1 mt-1')
									]),
								A2(
									$elm$core$List$map,
									function (genre) {
										return A2(
											$elm$html$Html$span,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('bg-background-light bg-opacity-50 px-1 py-0.5 rounded text-white text-xs')
												]),
											_List_fromArray(
												[
													$elm$html$Html$text(genre)
												]));
									},
									A2($elm$core$List$take, 2, item.as))) : $elm$html$Html$text('')
							]))
					]))
			]));
};
var $author$project$JellyfinUI$viewCategory = F2(
	function (model, category) {
		if ($elm$core$List$isEmpty(category.cu)) {
			return $elm$html$Html$text('');
		} else {
			var itemWidth = 200.0;
			var itemCount = $elm$core$List$length(category.cu);
			var displayCount = (model.x > 1600) ? 5.0 : ((model.x > 1200) ? 4.0 : ((model.x > 900) ? 3.0 : ((model.x > 600) ? 2.0 : 1.0)));
			var maxScrollPosition = (_Utils_cmp(itemCount, displayCount) < 1) ? 0.0 : (-((itemCount * itemWidth) - (displayCount * itemWidth)));
			var currentTranslation = A2(
				$elm$core$Maybe$withDefault,
				0,
				A2($elm$core$Dict$get, category.E, model.ab));
			var isAtEnd = (_Utils_cmp(currentTranslation, maxScrollPosition) < 1) || (_Utils_cmp(itemCount, displayCount) < 1);
			var rightButtonStyle = isAtEnd ? _Utils_ap(
				$author$project$Theme$button(5),
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick($author$project$JellyfinUI$NoOp),
						$elm$html$Html$Attributes$class('flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed')
					])) : _Utils_ap(
				$author$project$Theme$button(5),
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick(
						A2($author$project$JellyfinUI$ScrollCategory, category.E, -1)),
						$elm$html$Html$Attributes$class('flex items-center justify-center w-6 h-6')
					]));
			var isAtStart = currentTranslation >= 0.0;
			var leftButtonStyle = isAtStart ? _Utils_ap(
				$author$project$Theme$button(5),
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick($author$project$JellyfinUI$NoOp),
						$elm$html$Html$Attributes$class('flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed')
					])) : _Utils_ap(
				$author$project$Theme$button(5),
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick(
						A2($author$project$JellyfinUI$ScrollCategory, category.E, 1)),
						$elm$html$Html$Attributes$class('flex items-center justify-center w-6 h-6')
					]));
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('space-y-2')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex justify-between items-center mx-1')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$h2,
								_Utils_ap(
									$author$project$Theme$text(2),
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('font-bold text-primary')
										])),
								_List_fromArray(
									[
										$elm$html$Html$text(category.aw)
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex items-center space-x-1')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$button,
										leftButtonStyle,
										_List_fromArray(
											[
												$elm$html$Html$text('←')
											])),
										A2(
										$elm$html$Html$button,
										rightButtonStyle,
										_List_fromArray(
											[
												$elm$html$Html$text('→')
											])),
										A2(
										$elm$html$Html$button,
										_Utils_ap(
											$author$project$Theme$button(5),
											_List_fromArray(
												[
													$elm$html$Html$Events$onClick(
													$author$project$JellyfinUI$SelectCategory(category.E)),
													$elm$html$Html$Attributes$class('py-1 px-2')
												])),
										_List_fromArray(
											[
												$elm$html$Html$text('See All')
											]))
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('relative overflow-hidden')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex space-x-2 hide-scrollbar'),
										A2(
										$elm$html$Html$Attributes$style,
										'transform',
										'translateX(' + ($elm$core$String$fromFloat(currentTranslation) + 'px)')),
										A2($elm$html$Html$Attributes$style, 'transition', 'transform 0.4s ease'),
										A2($elm$html$Html$Attributes$style, 'width', '100%'),
										A2($elm$html$Html$Attributes$style, 'overscroll-behavior-x', 'contain')
									]),
								$elm$core$List$isEmpty(category.cu) ? _List_fromArray(
									[
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('w-full text-center p-6')
											]),
										_List_fromArray(
											[
												A2(
												$elm$html$Html$p,
												$author$project$Theme$text(3),
												_List_fromArray(
													[
														$elm$html$Html$text('No items in this category')
													]))
											]))
									]) : A2(
									$elm$core$List$map,
									function (item) {
										return A2(
											$elm$html$Html$div,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('flex-shrink-0 w-52 relative py-2 px-1 overflow-visible'),
													A2($elm$html$Html$Attributes$style, 'min-width', '185px')
												]),
											_List_fromArray(
												[
													$author$project$JellyfinUI$viewMediaItem(item)
												]));
									},
									category.cu))
							]))
					]));
		}
	});
var $author$project$JellyfinUI$viewAllCategories = function (model) {
	var filteredCategories = A2(
		$author$project$JellyfinUI$filterCategoriesByType,
		model.C,
		A2(
			$author$project$JellyfinUI$filterCategoriesByGenre,
			model.B,
			A2($author$project$JellyfinUI$filterCategories, model.aj, model.u)));
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('space-y-6')
			]),
		A2(
			$elm$core$List$map,
			$author$project$JellyfinUI$viewCategory(model),
			filteredCategories));
};
var $author$project$JellyfinUI$ClearCategory = {$: 2};
var $author$project$JellyfinUI$viewMediaItemLarge = function (item) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex flex-col bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary group h-full'),
				$elm$html$Html$Events$onClick(
				$author$project$JellyfinUI$SelectMediaItem(item.E))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('relative pt-[150%]')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute inset-0 bg-surface-light flex items-center justify-center transition-all duration-300 group-hover:brightness-110'),
								A2($elm$html$Html$Attributes$style, 'background-image', 'linear-gradient(rgba(40, 40, 40, 0.2), rgba(30, 30, 30, 0.8))')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-4xl text-primary-light opacity-70')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('🎬')
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-20')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('bg-primary text-white rounded-full w-20 h-20 flex items-center justify-center opacity-0 group-hover:opacity-90 hover:opacity-100 transition-all duration-300 cursor-pointer hover:scale-110'),
										A2($elm$html$Html$Attributes$style, 'box-shadow', '0 0 30px 10px rgba(95, 135, 175, 0.7)'),
										$elm$html$Html$Events$onClick(
										$author$project$JellyfinUI$PlayMedia(item.E))
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$span,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('text-3xl font-bold'),
												A2($elm$html$Html$Attributes$style, 'margin-left', '4px')
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('▶')
											]))
									]))
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('p-4 flex-grow transition-colors duration-300 group-hover:bg-surface-light')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h3,
						_Utils_ap(
							$author$project$Theme$text(2),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('truncate group-hover:text-primary transition-colors duration-300')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(item.aP)
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex justify-between items-center mt-2')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex items-center space-x-2')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$span,
										$author$project$Theme$text(4),
										_List_fromArray(
											[
												$elm$html$Html$text(
												$author$project$JellyfinUI$mediaTypeToString(item.aQ))
											])),
										A2(
										$elm$html$Html$span,
										$author$project$Theme$text(4),
										_List_fromArray(
											[
												$elm$html$Html$text(
												'(' + ($elm$core$String$fromInt(item.aS) + ')'))
											]))
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex items-center')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$span,
										_Utils_ap(
											$author$project$Theme$text(4),
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('text-warning')
												])),
										_List_fromArray(
											[
												$elm$html$Html$text(
												'★ ' + $elm$core$String$fromFloat(item.aJ))
											]))
									]))
							])),
						A2(
						$elm$html$Html$p,
						_Utils_ap(
							$author$project$Theme$text(4),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('mt-2 line-clamp-2')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(
								A2($elm$core$Maybe$withDefault, 'No description available.', item.aD))
							]))
					]))
			]));
};
var $author$project$JellyfinUI$viewCategoryDetail = F2(
	function (model, categoryId) {
		var filteredCategories = A2(
			$author$project$JellyfinUI$filterCategoriesByType,
			model.C,
			A2(
				$author$project$JellyfinUI$filterCategoriesByGenre,
				model.B,
				A2($author$project$JellyfinUI$filterCategories, model.aj, model.u)));
		var _v0 = A2($author$project$JellyfinUI$findCategory, categoryId, filteredCategories);
		if (!_v0.$) {
			var category = _v0.a;
			return A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center mb-3 mt-1')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_Utils_ap(
									$author$project$Theme$button(5),
									_List_fromArray(
										[
											$elm$html$Html$Events$onClick($author$project$JellyfinUI$ClearCategory),
											$elm$html$Html$Attributes$class('mr-2')
										])),
								_List_fromArray(
									[
										$elm$html$Html$text('← Back')
									])),
								A2(
								$elm$html$Html$h2,
								_Utils_ap(
									$author$project$Theme$text(1),
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('font-bold text-primary')
										])),
								_List_fromArray(
									[
										$elm$html$Html$text(category.aw)
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 px-4')
							]),
						A2($elm$core$List$map, $author$project$JellyfinUI$viewMediaItemLarge, category.cu))
					]));
		} else {
			return A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Category not found')
					]));
		}
	});
var $author$project$JellyfinUI$viewContent = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('px-4 max-w-screen-2xl mx-auto space-y-4 mb-4')
			]),
		_List_fromArray(
			[
				((!_Utils_eq(model.B, $elm$core$Maybe$Nothing)) || (!_Utils_eq(model.C, $elm$core$Maybe$Nothing))) ? A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex items-center py-1 space-x-2 flex-wrap')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$span,
						$author$project$Theme$text(5),
						_List_fromArray(
							[
								$elm$html$Html$text('Active filters:')
							])),
						$author$project$JellyfinUI$viewActiveFilter(model.B),
						$author$project$JellyfinUI$viewActiveTypeFilter(model.C)
					])) : $elm$html$Html$text(''),
				function () {
				var _v0 = model.ay;
				if (!_v0.$) {
					var categoryId = _v0.a;
					return A2($author$project$JellyfinUI$viewCategoryDetail, model, categoryId);
				} else {
					return $author$project$JellyfinUI$viewAllCategories(model);
				}
			}()
			]));
};
var $author$project$JellyfinUI$RetryLoadTMDBData = {$: 20};
var $author$project$JellyfinUI$viewError = function (errorMessage) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex flex-col items-center justify-center h-48 px-4')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('bg-error bg-opacity-20 border border-error rounded-lg p-4 max-w-md')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h3,
						_Utils_ap(
							$author$project$Theme$text(2),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-error mb-2')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text('Error Loading Data')
							])),
						A2(
						$elm$html$Html$p,
						_Utils_ap(
							$author$project$Theme$text(3),
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('mb-4')
								])),
						_List_fromArray(
							[
								$elm$html$Html$text(errorMessage)
							])),
						A2(
						$elm$html$Html$button,
						_Utils_ap(
							$author$project$Theme$button(0),
							_List_fromArray(
								[
									$elm$html$Html$Events$onClick($author$project$JellyfinUI$RetryLoadTMDBData)
								])),
						_List_fromArray(
							[
								$elm$html$Html$text('Retry')
							]))
					]))
			]));
};
var $author$project$JellyfinUI$SearchInput = function (a) {
	return {$: 0, a: a};
};
var $elm$html$Html$header = _VirtualDom_node('header');
var $elm$html$Html$input = _VirtualDom_node('input');
var $elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var $elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 1, a: a};
};
var $elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$html$Html$Events$targetValue = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	$elm$json$Json$Decode$string);
var $elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		$elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			$elm$json$Json$Decode$map,
			$elm$html$Html$Events$alwaysStop,
			A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue)));
};
var $elm$html$Html$Attributes$placeholder = $elm$html$Html$Attributes$stringProperty('placeholder');
var $elm$html$Html$Attributes$value = $elm$html$Html$Attributes$stringProperty('value');
var $author$project$JellyfinUI$ToggleGenreFilter = {$: 12};
var $author$project$JellyfinUI$SelectGenre = function (a) {
	return {$: 13, a: a};
};
var $author$project$JellyfinUI$viewGenreOption = function (genre) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary'),
				$elm$html$Html$Events$onClick(
				$author$project$JellyfinUI$SelectGenre(genre))
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(genre)
			]));
};
var $author$project$JellyfinUI$viewGenreDropdown = function (genres) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('absolute right-0 mt-1 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('bg-surface border-b border-background-light p-1')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$p,
						$author$project$Theme$text(5),
						_List_fromArray(
							[
								$elm$html$Html$text('Select Genre')
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('max-h-64 overflow-y-auto py-1')
					]),
				A2($elm$core$List$map, $author$project$JellyfinUI$viewGenreOption, genres))
			]));
};
var $author$project$JellyfinUI$viewGenreFilter = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('relative')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$button,
				_Utils_ap(
					$author$project$Theme$button(5),
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center space-x-1 py-1 px-2'),
							$elm$html$Html$Events$onClick($author$project$JellyfinUI$ToggleGenreFilter)
						])),
				_List_fromArray(
					[
						$elm$html$Html$text(
						function () {
							var _v0 = model.B;
							if (!_v0.$) {
								var genre = _v0.a;
								return 'Genre: ' + genre;
							} else {
								return 'Filter by Genre';
							}
						}()),
						(!_Utils_eq(model.B, $elm$core$Maybe$Nothing)) ? A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('ml-1 text-text-secondary hover:text-error'),
								$elm$html$Html$Events$onClick($author$project$JellyfinUI$ClearGenreFilter)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('×')
							])) : $elm$html$Html$text('')
					])),
				model.I ? $author$project$JellyfinUI$viewGenreDropdown(model.aq) : $elm$html$Html$text('')
			]));
};
var $author$project$JellyfinUI$ToggleTypeFilter = {$: 15};
var $author$project$JellyfinUI$SelectType = function (a) {
	return {$: 16, a: a};
};
var $author$project$JellyfinUI$viewTypeOption = function (mediaType) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary'),
				$elm$html$Html$Events$onClick(
				$author$project$JellyfinUI$SelectType(mediaType))
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(
				$author$project$JellyfinUI$mediaTypeToString(mediaType))
			]));
};
var $author$project$JellyfinUI$viewTypeDropdown = A2(
	$elm$html$Html$div,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$class('absolute right-0 mt-1 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light')
		]),
	_List_fromArray(
		[
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('bg-surface border-b border-background-light p-1')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$p,
					$author$project$Theme$text(5),
					_List_fromArray(
						[
							$elm$html$Html$text('Select Media Type')
						]))
				])),
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('py-1')
				]),
			_List_fromArray(
				[
					$author$project$JellyfinUI$viewTypeOption(0),
					$author$project$JellyfinUI$viewTypeOption(1)
				]))
		]));
var $author$project$JellyfinUI$viewTypeFilter = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('relative')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$button,
				_Utils_ap(
					$author$project$Theme$button(5),
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center space-x-1 py-1 px-2'),
							$elm$html$Html$Events$onClick($author$project$JellyfinUI$ToggleTypeFilter)
						])),
				_List_fromArray(
					[
						$elm$html$Html$text(
						function () {
							var _v0 = model.C;
							if (!_v0.$) {
								var mediaType = _v0.a;
								return 'Type: ' + $author$project$JellyfinUI$mediaTypeToString(mediaType);
							} else {
								return 'Filter by Type';
							}
						}()),
						(!_Utils_eq(model.C, $elm$core$Maybe$Nothing)) ? A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('ml-1 text-text-secondary hover:text-error'),
								$elm$html$Html$Events$onClick($author$project$JellyfinUI$ClearTypeFilter)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('×')
							])) : $elm$html$Html$text('')
					])),
				model.K ? $author$project$JellyfinUI$viewTypeDropdown : $elm$html$Html$text('')
			]));
};
var $author$project$JellyfinUI$ToggleUserMenu = {$: 10};
var $author$project$JellyfinUI$viewUserMenuHeader = A2(
	$elm$html$Html$div,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$class('px-3 py-2 border-b border-background-light')
		]),
	_List_fromArray(
		[
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center space-x-2')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('w-8 h-8 rounded-full bg-primary flex items-center justify-center text-text-primary')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('A')
						])),
					A2(
					$elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							$elm$html$Html$p,
							_Utils_ap(
								$author$project$Theme$text(3),
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('font-medium')
									])),
							_List_fromArray(
								[
									$elm$html$Html$text('Administrator')
								])),
							A2(
							$elm$html$Html$p,
							$author$project$Theme$text(4),
							_List_fromArray(
								[
									$elm$html$Html$text('admin@jellyfin.org')
								]))
						]))
				]))
		]));
var $author$project$JellyfinUI$UserMenuAction = function (a) {
	return {$: 11, a: a};
};
var $author$project$JellyfinUI$viewUserMenuItem = F3(
	function (label, description, action) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('px-3 py-1 hover:bg-background-light cursor-pointer'),
					$elm$html$Html$Events$onClick(
					$author$project$JellyfinUI$UserMenuAction(action))
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$p,
					_Utils_ap(
						$author$project$Theme$text(3),
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('font-medium')
							])),
					_List_fromArray(
						[
							$elm$html$Html$text(label)
						])),
					A2(
					$elm$html$Html$p,
					$author$project$Theme$text(4),
					_List_fromArray(
						[
							$elm$html$Html$text(description)
						]))
				]));
	});
var $author$project$JellyfinUI$viewUserMenu = A2(
	$elm$html$Html$div,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$class('absolute right-0 mt-1 w-56 bg-surface rounded-md shadow-lg py-1 z-50 border border-background-light')
		]),
	_List_fromArray(
		[
			$author$project$JellyfinUI$viewUserMenuHeader,
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Profile', 'User profile and settings', 'profile'),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Display Preferences', 'Customize your experience', 'display'),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Watch Party', 'Watch with a group', 'watchParty'),
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('border-t border-background-light my-1')
				]),
			_List_Nil),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Manage Libraries', 'Organize your media collection', 'libraries'),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Manage Users', 'Add or edit user access', 'users'),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Server Dashboard', 'System status and settings', 'dashboard'),
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('border-t border-background-light my-1')
				]),
			_List_Nil),
			A3($author$project$JellyfinUI$viewUserMenuItem, 'Sign Out', 'Exit your account', 'signout')
		]));
var $author$project$JellyfinUI$viewUserProfile = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('relative')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$button,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('w-8 h-8 rounded-full bg-primary flex items-center justify-center text-text-primary hover:bg-primary-dark transition-colors focus:outline-none focus:ring-2 focus:ring-primary-light'),
						$elm$html$Html$Events$onClick($author$project$JellyfinUI$ToggleUserMenu)
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('A')
					])),
				model.L ? $author$project$JellyfinUI$viewUserMenu : $elm$html$Html$text('')
			]));
};
var $author$project$JellyfinUI$viewHeader = function (model) {
	return A2(
		$elm$html$Html$header,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('bg-surface border-b border-background-light py-2 px-3')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('px-1 md:px-2 max-w-screen-2xl mx-auto flex items-center justify-between')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center space-x-3')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$h1,
								$author$project$Theme$text(1),
								_List_fromArray(
									[
										$elm$html$Html$text('Jellyfin')
									])),
								A2(
								$elm$html$Html$span,
								$author$project$Theme$text(4),
								_List_fromArray(
									[
										$elm$html$Html$text('Media Server')
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('w-full max-w-md mx-2')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('relative')
									]),
								_List_fromArray(
									[
										A2(
										$elm$html$Html$input,
										_Utils_ap(
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('w-full bg-background border border-background-light rounded py-1 px-3 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary focus:ring-opacity-50'),
													$elm$html$Html$Attributes$placeholder('Search media...'),
													$elm$html$Html$Attributes$value(model.aj),
													$elm$html$Html$Events$onInput($author$project$JellyfinUI$SearchInput)
												]),
											$author$project$Theme$text(3)),
										_List_Nil)
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center space-x-2')
							]),
						_List_fromArray(
							[
								$author$project$JellyfinUI$viewTypeFilter(model),
								$author$project$JellyfinUI$viewGenreFilter(model),
								$author$project$JellyfinUI$viewUserProfile(model)
							]))
					]))
			]));
};
var $author$project$JellyfinUI$viewLoading = A2(
	$elm$html$Html$div,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$class('flex justify-center items-center h-48')
		]),
	_List_fromArray(
		[
			A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('text-primary text-xl')
				]),
			_List_fromArray(
				[
					$elm$html$Html$text('Loading...')
				]))
		]));
var $author$project$JellyfinUI$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex flex-col min-h-screen bg-background overflow-x-hidden')
			]),
		_List_fromArray(
			[
				$author$project$JellyfinUI$viewHeader(model),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex-1 overflow-y-auto pt-10 pb-8 overflow-x-hidden')
					]),
				_List_fromArray(
					[
						function () {
						if (model.J) {
							return $author$project$JellyfinUI$viewLoading;
						} else {
							var _v0 = model.ad;
							if (!_v0.$) {
								var error = _v0.a;
								return $author$project$JellyfinUI$viewError(error);
							} else {
								return $author$project$JellyfinUI$viewContent(model);
							}
						}
					}()
					])),
				A2(
				$elm$html$Html$map,
				$author$project$JellyfinUI$MediaDetailMsg,
				$author$project$MediaDetail$view(model.ai))
			]));
};
var $author$project$Main$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('min-h-screen bg-background')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$map,
				$elm$core$Basics$identity,
				$author$project$JellyfinUI$view(model.ah))
			]));
};
var $author$project$Main$main = $elm$browser$Browser$element(
	{cs: $author$project$Main$init, cV: $author$project$Main$subscriptions, cZ: $author$project$Main$update, c$: $author$project$Main$view});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(0))(0)}});}(this));
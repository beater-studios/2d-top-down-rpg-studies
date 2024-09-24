/// @function approach(start, end, shift)
/// @description Move start towards end by shift amount
/// @param {Real} _start - The starting value
/// @param {Real} _end - The ending value
/// @param {Real} _shift - The amount to move by
/// @return {Real} - The new value after moving towards end by shift
function approach(_start, _end, _shift) {
    if (_start < _end) {
        return min(_start + _shift, _end);
    } else {
        return max(_start - _shift, _end);
    }
}

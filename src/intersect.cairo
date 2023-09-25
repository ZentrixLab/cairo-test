// IMPLEMENTATION OF INTERSECT USING FELT252DICT DATA STRUCTURE
// Felt252Dict should simulate HashMap and mutable writes in an immutable
// environment, however it is implemented using array of entries. The
// Cairo Book states that the worst case time complexity when interacting with
// Felt252Dict is O(n), however the execution time is blazingly fast when
// compared to the loops implementation, which leads us to suspect that O(n)
// is actually not the case when interacting with Felt252Dict.
fn intersect_dict<
    T,
    impl TPartialOrd: PartialEq<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
    impl TInto: Into<T, felt252>
>(
    first: @Array<T>, second: @Array<T>
) -> Option<Array<T>> {
    // Using u8 for dict value type because boolean is being refused.
    // It panics during runtime. The book states that bool value is
    // supported and had default value implemented.
    let mut dict: Felt252Dict<u8> = Default::default();
    let mut result: Array<T> = ArrayTrait::new();
    let mut index: usize = 0;

    loop {
        if index >= first.len() {
            break;
        }
        dict.insert((*first.at(index)).into(), 1);
        index += 1;
    };
    index = 0;

    loop {
        if index >= second.len() {
            break;
        }
        let key: felt252 = (*second.at(index)).into();
        if dict.get(key) == 1 {
            result.append(*second.at(index));
            dict.insert(key, 2);
        }
        index += 1;
    };

    if result.len() != 0 {
        Option::Some(result)
    } else {
        Option::None
    }
}

// TESTS
#[cfg(test)]
mod tests {
    use super::intersect_dict;

    #[test]
    #[available_gas(50000000)]
    fn dict_intersects_on_500_elements() {
        let mut first = ArrayTrait::<u32>::new();
        let mut second = ArrayTrait::<u32>::new();
        let mut i: u32 = 0;
        loop {
            if i >= 1000 {
                break;
            }
            first.append(i);
            second.append(i + 500);
            i += 1;
        };

        let c = intersect_dict(@first, @second).unwrap();
        assert(c.len() == 500, 'Failed to match intersection');
    }

    #[test]
    #[available_gas(300000)]
    fn dict_intersects_on_3_elements() {
        let first = array![1, 2, 3, 4, 5];
        let second = array![3, 4, 5, 6, 7];
        let intersection = array![3, 4, 5];

        let result = intersect_dict(@first, @second).unwrap();
        assert(result == intersection, 'Failed to intersect on 3');
    }

    #[test]
    #[available_gas(300000)]
    fn dict_none_on_empty_intersection() {
        let first = array![1, 2, 3, 4, 5];
        let second = array![10, 11];

        let result = intersect_dict(@first, @second);
        assert(result == Option::None, 'Failed to intersect empty');
    }
}

use debug::PrintTrait;
// Error when trying to create Felt252Dict<bool> ??

// @dev Function checks if two arrays have at least one same element
// @param array1 snapshot of felt252 array
// @param array2 snapshot of felt252 array
// @returns bool
fn intersect(array1: @Array<felt252>, array2: @Array<felt252>) -> bool {
    let mut dict: Felt252Dict<u8> = Default::default();
    let mut cnt: usize = 0; 

    let array1_len = array1.len();
    let array2_len = array2.len();

    // inserting elements of the first array in dict
    loop {
        if (cnt < array1_len) {
            dict.insert(*array1[cnt], 1);
        } else {
            break;
        }
        cnt += 1;
    };

    cnt = 0;

    // inserting elements of the second array in dict
    let result = loop {
        if (cnt < array2_len) {
            // check for intersection
            if (dict.get(*array2[cnt]) == 1) {
                break true;
            }
        } else {
            break false;
        }
        cnt += 1;
    };
    // else return false
    result
}

// @dev Function checks if two arrays have same elements and returns those elements in an array
// @param array1 snapshot of felt252 array
// @param array2 snapshot of felt252 array
// @returns Option<Array<felt252>>
fn intersection(array1: @Array<felt252>, array2: @Array<felt252>) -> Option<Array<felt252>> {
    let mut dict: Felt252Dict<u8> = Default::default();
    let mut intersection_array: Array<felt252> = ArrayTrait::new();
    let mut cnt: usize = 0; 

    let array1_len = array1.len();
    let array2_len = array2.len();

    // inserting elements of the first array in dict
    loop {
        if (cnt < array1_len) {
            dict.insert(*array1[cnt], 1);
        } else {
            break;
        } 
        cnt += 1;
    };

    cnt = 0;
    // inserting elements of the second array in dict
    loop {
        if (cnt < array2_len) {
            // check for intersection
            if (dict.get(*array2[cnt]) == 1) {
                intersection_array.append(*array2[cnt]);
            }
        } else {
            break;
        }
        cnt += 1;
    };

    // else return false
    if intersection_array.is_empty() {
        Option::None(())
    } else {
        Option::Some(intersection_array)
    }
}

fn main() {
    // let array1 = array![1, 2, 3];
    // let array2 = array![5, 6, 1];

    // let result = intersect(@array1, @array2);
    // let result2 = intersection(@array1, @array2);
    // result.print();

    // match result2 {
    //     Option::Some(array) => array.len().print(),
    //     Option::None(_) => 'no intersection'.print(), 
    // }

    let array1 = create_array_in_range(0, 1000);
    let array2 = create_array_in_range(500, 1500);
    let res = intersection(@array1, @array2);
}

fn create_array_in_range(start: u32, end: u32) -> Array<felt252> {
    let mut array: Array<felt252> = ArrayTrait::new();
    let mut i = start;
    loop {
        if (i < end) {
            let val: felt252 = i.into();
            array.append(val);
        }
        else {
            break;
        }
        i += 1;
    };
    array
}

#[cfg(test)]
mod tests {
    use core::array::ArrayTrait;
    use core::debug::PrintTrait;
    use super::{intersect, intersection};
    use super::create_array_in_range;

    #[test]
    #[available_gas(5000000)]
    fn intersect_test_false() {
        let array1 = array![1, 2, 3, 4, 5, 6, 7];
        let array2 = array![8, 9, 10, 11, 12, 13, 14, 15];

        let result = intersect(@array1, @array2);
        assert(result == false, 'arrays dont intersect');
    }

    #[test]
    #[available_gas(5000000)]
    fn intersect_test_true() {
        let array1 = array![1, 2, 3, 4, 5, 6, 7];
        let array2 = array![8, 9, 10, 11, 4, 13, 14, 15];

        let result = intersect(@array1, @array2);
        assert(result == true, 'arrays intersect');
    }
    
    #[test]
    #[available_gas(5000000)]
    fn intersection_test_some() {
        let array1 = array![1, 2, 3, 4, 5, 6, 7];
        let array2 = array![8, 9, 10, 11, 12, 13, 14, 15];

        let result = intersection(@array1, @array2);
        assert(result == Option::None, 'arrays dont intersect');
    }

    #[test]
    #[available_gas(50000000)]
    fn intersection_test_none() {
        let array1 = array![1, 2, 3, 4, 5, 6, 7];
        let array2 = array![1, 2, 3, 4, 5, 6, 7];

        let result = intersection(@array1, @array2);

        let array = match result {
            Option::Some(arr) => arr,
            Option::None(()) => ArrayTrait::new(),
        };
        assert(array.len() == array1.len(), 'arrays are same');
    }

    #[test]
    #[available_gas(50000000)]
                    
    fn test_big_numbers() {
        let array1 = create_array_in_range(0, 1000);
        let array2 = create_array_in_range(500, 1500);
        let res = intersection(@array1, @array2);


        let array = match res {
            Option::Some(arr) => arr,
            Option::None(()) => ArrayTrait::new(),
        };
        assert(array.len() == 500, 'not equal 500');
    }
}
use debug::PrintTrait;

// Drugi tip podpograma bi trebalo da proveri ispunjenost nekog algebarskog uslova (da li je ulaz1 veci za 10% od drugog ulaza).
fn is_10_percent_greater(a: u64, b: u64) -> bool {
    a > (b + (b * 10 / 100))
}

#[derive(Drop, Copy)]
enum Ops {
    Equal,
    GreaterThen,
    LessThen,
    GreaterOrEqThen,
    LessOrEqThen,
}

fn compare(input_1: u32, input_2: u32, op: Ops, percent: u32) -> bool {
    let compare_to = input_2 + input_2 * percent / 100;
    match op {
        Ops::Equal => input_1 == compare_to,
        Ops::GreaterThen => input_1 > compare_to,
        Ops::LessThen => input_1 < compare_to,
        Ops::GreaterOrEqThen => input_1 >= compare_to,
        Ops::LessOrEqThen => input_1 <= compare_to,
    }
}

fn main() {
    let val1 = 2;
    let val2 = 1;
    compare(val1, val2, Ops::GreaterThen, 100).print(); 
}

#[cfg(test)]
mod tests {
    use super::compare;
    use super::Ops;

    #[test]
    fn test1() {
        let val1 = 2;
        let val2 = 1;
        assert(compare(val1, val2, Ops::GreaterThen, 100) == false, '2 > 2');
    }

    #[test]
    fn test2() {
        let val1 = 2;
        let val2 = 1;
        assert(compare(val1, val2, Ops::GreaterOrEqThen, 100) == true, '2 >= 2');
    }

    #[test]
    fn test3() {
        let val1 = 110;
        let val2 = 100;
        assert(compare(val1, val2, Ops::Equal, 10) == true, '110 == 110');
    }

    #[test]
    fn test4() {
        let val1 = 130;
        let val2 = 100;
        assert(compare(val1, val2, Ops::LessOrEqThen, 30) == true, '130 <= 130');
    }
}

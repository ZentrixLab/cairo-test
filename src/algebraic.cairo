#[derive(Drop)]
enum CmpType<T> {
    Gt: (T, T),
    Lt: (T, T),
    Gte: (T, T),
    Lte: (T, T),
}

// The main issue with this implementation was making it as generic as
// possible across comparable types which implement ordering and
// basic operations traits. Basically this was the main driving motivation
// for implementing this function, as the fuctionality is fairly simple.
fn execute_check<
    T,
    impl TPartialOrd: PartialOrd<T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TAdd: Add<T>,
    impl TMul: Mul<T>,
    impl TDiv: Div<T>,
>(
    x: T, y: T, cmp: CmpType<T>
) -> bool {
    match cmp {
        CmpType::Gt((parts, magnitude)) => x > (y + (y * parts) / magnitude),
        CmpType::Lt((parts, magnitude)) => x < (y + (y * parts) / magnitude),
        CmpType::Gte((parts, magnitude)) => x >= (y + (y * parts) / magnitude),
        CmpType::Lte((parts, magnitude)) => x <= (y + (y * parts) / magnitude),
    }
}

#[cfg(test)]
mod tests {
    use super::execute_check;
    use super::CmpType;

    #[test]
    #[available_gas(1000000)]
    fn correct_gt_by_10_percent() {
        let a: u32 = 34;
        let b: u32 = 30;

        assert(execute_check(a, b, CmpType::Gt((10, 100))) == true, 'Failed gt by 10%');
    }

    #[test]
    #[available_gas(1000000)]
    fn correct_gte_by_30_percent() {
        let a: u16 = 36;
        let b: u16 = 30;
        assert(execute_check(a, b, CmpType::Gte((20, 100))) == true, 'Failed gte by 30%');
    }

    #[test]
    #[available_gas(1000000)]
    fn correct_lte_by_30_percent_true() {
        let a: u64 = 390;
        let b: u64 = 300;
        assert(execute_check(a, b, CmpType::Lte((30, 100))) == true, 'Failed lte by 30%');
    }

    #[test]
    #[available_gas(1000000)]
    fn correct_lte_by_30_percent_false() {
        let a: u64 = 391;
        let b: u64 = 300;
        assert(execute_check(a, b, CmpType::Lte((30, 100))) == false, 'Failed lt3 by 30%');
    }

    #[test]
    #[available_gas(1000000)]
    fn correct_lt_by_300_per_thousand() {
        let a: u128 = 389;
        let b: u128 = 300;
        assert(execute_check(a, b, CmpType::Lt((300, 1000))) == true, 'Failed lt by 300%o');
    }
}

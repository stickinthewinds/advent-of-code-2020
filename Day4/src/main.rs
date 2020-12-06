extern crate regex;

use std::env;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::string::String;
use std::collections::HashMap;
use regex::Regex;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut passports: Vec<HashMap<_,_>> = Vec::new();
    let mut current: String = String::from("");

    if args.len() == 2 {
        if let Ok(lines) = read_lines(&args[1]) {
            // Consumes the iterator, returns an (Optional) String
            for line in lines {
                if let Ok(content) = line {
                    if content == "" {
                        let passport: HashMap<_,_> = process_passport(&current);
                        passports.push(passport);
                        current = String::from("");
                    } else {
                        current.push_str(" ");
                        current.push_str(&content);
                    }
                }
            }
            // Extra in case there is no empty line at the end of file
            let passport: HashMap<_,_> = process_passport(&current);
            passports.push(passport);

            let valid: i32 = check_passports(passports);
            println!("Valid passports: {}", valid);
        }
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn process_passport(text: &str) -> HashMap<String,String> {
    let mut passport: HashMap<_,_> = HashMap::new();
    if text != "" {
        let pairs = text.split_whitespace();
        for pair in pairs {
            let item = pair.split(":");
            let vec: Vec<&str> = item.collect();
            let field:String = String::from(vec[0]);
            let value = String::from(vec[1]);
            passport.insert(field, value);
        }
    }

    return passport;
}

// byr, iyr, eyr, hgt, hcl, ecl, pid, cid
fn check_passports(passports: Vec<HashMap<String,String>>) -> i32 {
    let mut valid: i32 = 0;
    for passport in passports {
        if validate_passport(&passport) {
            if passport.len() == 8 {
                valid += 1;
            } else if passport.len() == 7 && !passport.contains_key("cid") {
                valid += 1;
            }
        }

    }
    return valid;
}

fn validate_passport(passport: &HashMap<String,String>) -> bool {
    let mut valid: bool = true;
    for (key, val) in passport {
        if valid == true {
            let new_valid = match key.as_ref() {
                "byr" => validate_byr(val),
                "iyr" => validate_iyr(val),
                "eyr" => validate_eyr(val),
                "hgt" => validate_hgt(val),
                "hcl" => validate_hcl(val),
                "ecl" => validate_ecl(val),
                "pid" => validate_pid(val),
                "cid" => true,
                _ => panic!("Invalid field in passport: {}", key),
            };
            valid = new_valid;
        }
    }
    return valid;
}

fn validate_byr(value: &str) -> bool {
    let byr = value.parse::<i32>().unwrap();
    return byr >= 1920 && byr <= 2002;
}

fn validate_iyr(value: &str) -> bool {
    let byr = value.parse::<i32>().unwrap();
    return byr >= 2010 && byr <= 2020;
}

fn validate_eyr(value: &str) -> bool {
    let byr = value.parse::<i32>().unwrap();
    return byr >= 2020 && byr <= 2030;
}

fn validate_hgt(value: &str) -> bool {
    let re = Regex::new(r"^\d*(cm|in)").unwrap();
    if re.is_match(value) {
        let length: usize = value.len();
        let num: i32 = value[..length-2].parse::<i32>().unwrap();
        let h_type = &value[length-2..];

        if h_type == "cm" && num >= 150 && num <= 193 {
            return true;
        } else if h_type == "in" && num >= 59 && num <= 76 {
            return true;
        }
    }
    return false;
}

fn validate_hcl(value: &str) -> bool {
    let re = Regex::new(r"^#[\da-f]{6}").unwrap();
    return re.is_match(value);
}

fn validate_ecl(value: &str) -> bool {
    let re = Regex::new(r"^(amb|blu|brn|gry|grn|hzl|oth){1}$").unwrap();
    return re.is_match(value);
}

fn validate_pid(value: &str) -> bool {
    let re = Regex::new(r"^\d{9}$").unwrap();
    return re.is_match(value);
}

// Unit testing of the validations
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_byr() {
        let valid = "2002";
        let invalid = "2003";
        assert_eq!(validate_byr(valid), true);
        assert_eq!(validate_byr(invalid), false);
    }

    #[test]
    fn test_validate_iyr() {
        let valid = "2020";
        let invalid = "2021";
        assert_eq!(validate_iyr(valid), true);
        assert_eq!(validate_iyr(invalid), false);
    }

    #[test]
    fn test_validate_eyr() {
        let valid = "2030";
        let invalid = "2031";
        assert_eq!(validate_eyr(valid), true);
        assert_eq!(validate_eyr(invalid), false);
    }

    #[test]
    fn test_validate_hgt_cm() {
        let valid = "193cm";
        let invalid = "194cm";

        assert_eq!(validate_hgt(valid), true);
        assert_eq!(validate_hgt(invalid), false);
    }

    #[test]
    fn test_validate_hgt_in() {
        let valid = "76in";
        let invalid = "77in";

        assert_eq!(validate_hgt(valid), true);
        assert_eq!(validate_hgt(invalid), false);
    }

    #[test]
    fn test_validate_hcl() {
        let valid = "#0a1bf9";
        let invalid = "#0a1bg9";
        assert_eq!(validate_hcl(valid), true);
        assert_eq!(validate_hcl(invalid), false);
    }

    #[test]
    fn test_validate_ecl() {
        let valid = "brn";
        let invalid = "ambhzl";
        assert_eq!(validate_ecl(valid), true);
        assert_eq!(validate_ecl(invalid), false);
    }

    #[test]
    fn test_validate_pid() {
        let valid = "012345678";
        let invalid = "0123456789";
        assert_eq!(validate_pid(valid), true);
        assert_eq!(validate_pid(invalid), false);
    }
}
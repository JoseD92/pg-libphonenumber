#include "short_phone_number.h"

using namespace google::protobuf;
using namespace i18n::phonenumbers;

const PhoneNumberUtil* const PhoneNumberTooLongException::phoneUtil = PhoneNumberUtil::GetInstance();

PhoneNumberTooLongException::PhoneNumberTooLongException(const PhoneNumber& number, const char* msg) :
    _number(number), std::runtime_error(msg) {};

std::string PhoneNumberTooLongException::number_string() const {
    std::string formatted;
    phoneUtil->Format(number(), PhoneNumberUtil::INTERNATIONAL, &formatted);
    return formatted;
}

ShortPhoneNumber::ShortPhoneNumber(i18n::phonenumbers::PhoneNumber number) {
    uint32 country_code = number.country_code();
    if(country_code > MAX_COUNTRY_CODE) {
        throw PhoneNumberTooLongException(number, "Country code is too long");
    }
    this->country_code(country_code);

    uint64 national_number = number.national_number();
    if(national_number > MAX_NATIONAL_NUMBER) {
        throw PhoneNumberTooLongException(number, "National number is too long");
    }
    this->national_number(national_number);

    if(number.has_number_of_leading_zeros()) {
        uint32 leading_zeros = number.number_of_leading_zeros();
        if(leading_zeros > MAX_LEADING_ZEROS) {
            throw PhoneNumberTooLongException(number, "Too many leading zeros");
        }
        this->leading_zeros(leading_zeros);
    } else {
        this->leading_zeros(0);
    }
}

ShortPhoneNumber::operator PhoneNumber() const {
    PhoneNumber number;
    number.set_country_code(country_code());
    number.set_national_number(national_number());
    int32 leading_zeros = this->leading_zeros();
    number.set_italian_leading_zero(leading_zeros > 0);
    number.set_number_of_leading_zeros(leading_zeros);
    return number;
}

/**
 * Registration Validation Utilities
 * Real-time validation for registration forms (no availability checking)
 */

// US and Canada location data
export const LOCATION_DATA = {
US: {
name: 'United States',
states: {
'AL': { name: 'Alabama', cities: ['Birmingham', 'Montgomery', 'Mobile', 'Huntsville'] },
'AK': { name: 'Alaska', cities: ['Anchorage', 'Fairbanks', 'Juneau'] },
'AZ': { name: 'Arizona', cities: ['Phoenix', 'Tucson', 'Mesa', 'Scottsdale'] },
'AR': { name: 'Arkansas', cities: ['Little Rock', 'Fort Smith', 'Fayetteville'] },
'CA': { name: 'California', cities: ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'San Jose'] },
'CO': { name: 'Colorado', cities: ['Denver', 'Colorado Springs', 'Aurora', 'Fort Collins'] },
'CT': { name: 'Connecticut', cities: ['Hartford', 'New Haven', 'Stamford', 'Waterbury'] },
'DE': { name: 'Delaware', cities: ['Wilmington', 'Dover', 'Newark'] },
'FL': { name: 'Florida', cities: ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Fort Lauderdale'] },
'GA': { name: 'Georgia', cities: ['Atlanta', 'Augusta', 'Columbus', 'Savannah'] },
'HI': { name: 'Hawaii', cities: ['Honolulu', 'Hilo', 'Kailua-Kona'] },
'ID': { name: 'Idaho', cities: ['Boise', 'Nampa', 'Meridian'] },
'IL': { name: 'Illinois', cities: ['Chicago', 'Aurora', 'Rockford', 'Joliet'] },
'IN': { name: 'Indiana', cities: ['Indianapolis', 'Fort Wayne', 'Evansville'] },
'IA': { name: 'Iowa', cities: ['Des Moines', 'Cedar Rapids', 'Davenport'] },
'KS': { name: 'Kansas', cities: ['Wichita', 'Overland Park', 'Kansas City'] },
'KY': { name: 'Kentucky', cities: ['Louisville', 'Lexington', 'Bowling Green'] },
'LA': { name: 'Louisiana', cities: ['New Orleans', 'Baton Rouge', 'Shreveport'] },
'ME': { name: 'Maine', cities: ['Portland', 'Lewiston', 'Bangor'] },
'MD': { name: 'Maryland', cities: ['Baltimore', 'Frederick', 'Rockville'] },
'MA': { name: 'Massachusetts', cities: ['Boston', 'Worcester', 'Springfield', 'Cambridge'] },
'MI': { name: 'Michigan', cities: ['Detroit', 'Grand Rapids', 'Warren', 'Sterling Heights'] },
'MN': { name: 'Minnesota', cities: ['Minneapolis', 'Saint Paul', 'Rochester'] },
'MS': { name: 'Mississippi', cities: ['Jackson', 'Gulfport', 'Southaven'] },
'MO': { name: 'Missouri', cities: ['Kansas City', 'Saint Louis', 'Springfield'] },
'MT': { name: 'Montana', cities: ['Billings', 'Missoula', 'Great Falls'] },
'NE': { name: 'Nebraska', cities: ['Omaha', 'Lincoln', 'Bellevue'] },
'NV': { name: 'Nevada', cities: ['Las Vegas', 'Henderson', 'Reno'] },
'NH': { name: 'New Hampshire', cities: ['Manchester', 'Nashua', 'Concord'] },
'NJ': { name: 'New Jersey', cities: ['Newark', 'Jersey City', 'Paterson'] },
'NM': { name: 'New Mexico', cities: ['Albuquerque', 'Las Cruces', 'Rio Rancho'] },
'NY': { name: 'New York', cities: ['New York City', 'Buffalo', 'Rochester', 'Albany'] },
'NC': { name: 'North Carolina', cities: ['Charlotte', 'Raleigh', 'Greensboro', 'Durham'] },
'ND': { name: 'North Dakota', cities: ['Fargo', 'Bismarck', 'Grand Forks'] },
'OH': { name: 'Ohio', cities: ['Columbus', 'Cleveland', 'Cincinnati', 'Toledo'] },
'OK': { name: 'Oklahoma', cities: ['Oklahoma City', 'Tulsa', 'Norman'] },
'OR': { name: 'Oregon', cities: ['Portland', 'Salem', 'Eugene'] },
'PA': { name: 'Pennsylvania', cities: ['Philadelphia', 'Pittsburgh', 'Allentown'] },
'RI': { name: 'Rhode Island', cities: ['Providence', 'Warwick', 'Cranston'] },
'SC': { name: 'South Carolina', cities: ['Charleston', 'Columbia', 'North Charleston'] },
'SD': { name: 'South Dakota', cities: ['Sioux Falls', 'Rapid City', 'Aberdeen'] },
'TN': { name: 'Tennessee', cities: ['Nashville', 'Memphis', 'Knoxville'] },
'TX': { name: 'Texas', cities: ['Houston', 'San Antonio', 'Dallas', 'Austin', 'Fort Worth'] },
'UT': { name: 'Utah', cities: ['Salt Lake City', 'West Valley City', 'Provo'] },
'VT': { name: 'Vermont', cities: ['Burlington', 'Essex', 'South Burlington'] },
'VA': { name: 'Virginia', cities: ['Virginia Beach', 'Norfolk', 'Chesapeake', 'Richmond'] },
'WA': { name: 'Washington', cities: ['Seattle', 'Spokane', 'Tacoma'] },
'WV': { name: 'West Virginia', cities: ['Charleston', 'Huntington', 'Parkersburg'] },
'WI': { name: 'Wisconsin', cities: ['Milwaukee', 'Madison', 'Green Bay'] },
'WY': { name: 'Wyoming', cities: ['Cheyenne', 'Casper', 'Laramie'] }
}
},
CA: {
name: 'Canada',
states: {
'AB': { name: 'Alberta', cities: ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge'] },
'BC': { name: 'British Columbia', cities: ['Vancouver', 'Victoria', 'Surrey', 'Burnaby'] },
'MB': { name: 'Manitoba', cities: ['Winnipeg', 'Brandon', 'Steinbach'] },
'NB': { name: 'New Brunswick', cities: ['Saint John', 'Moncton', 'Fredericton'] },
'NL': { name: 'Newfoundland and Labrador', cities: ['St. Johns', 'Mount Pearl', 'Corner Brook'] },
'NS': { name: 'Nova Scotia', cities: ['Halifax', 'Sydney', 'Dartmouth'] },
'NT': { name: 'Northwest Territories', cities: ['Yellowknife', 'Hay River', 'Inuvik'] },
'NU': { name: 'Nunavut', cities: ['Iqaluit', 'Rankin Inlet', 'Arviat'] },
'ON': { name: 'Ontario', cities: ['Toronto', 'Ottawa', 'Mississauga', 'Brampton', 'Hamilton'] },
'PE': { name: 'Prince Edward Island', cities: ['Charlottetown', 'Summerside', 'Stratford'] },
'QC': { name: 'Quebec', cities: ['Montreal', 'Quebec City', 'Laval', 'Gatineau'] },
'SK': { name: 'Saskatchewan', cities: ['Saskatoon', 'Regina', 'Prince Albert'] },
'YT': { name: 'Yukon', cities: ['Whitehorse', 'Dawson City', 'Watson Lake'] }
}
}
};

export const validateUsername = (username) => {
const errors = [];

if (!username || username.length < 3) {
errors.push('Username must be at least 3 characters');
}

if (username && username.length > 50) {
errors.push('Username must be less than 50 characters');
}

if (username && !/^[a-zA-Z0-9_.+-]+$/.test(username)) {
errors.push('Username can only contain letters, numbers, dots, dashes, plus signs, and underscores');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validateEmail = (email) => {
const errors = [];
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

if (!email) {
errors.push('Email is required');
} else if (!emailRegex.test(email)) {
errors.push('Please enter a valid email address');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validatePassword = (password) => {
const errors = [];
const requirements = {
length: password && password.length >= 8,
uppercase: password && /[A-Z]/.test(password),
lowercase: password && /[a-z]/.test(password),
number: password && /\d/.test(password),
special: password && /[!@#$%^&*(),.?":{}|<>]/.test(password)
};

if (!password) {
errors.push('Password is required');
return { isValid: false, errors, requirements, strength: 'empty' };
}

if (!requirements.length) {
errors.push('Password must be at least 8 characters');
}

const strength = calculatePasswordStrength(requirements);

if (strength === 'weak') {
errors.push('Password is too weak');
}

return {
isValid: errors.length === 0 && strength !== 'weak',
errors,
requirements,
strength
};
};

const calculatePasswordStrength = (requirements) => {
const score = Object.values(requirements).filter(Boolean).length;
if (score < 3) return 'weak';
if (score < 5) return 'medium';
return 'strong';
};

export const validatePasswordMatch = (password, confirmPassword) => {
const errors = [];

if (!confirmPassword) {
errors.push('Please confirm your password');
} else if (password !== confirmPassword) {
errors.push('Passwords do not match');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validatePersonalInfo = (data) => {
const errors = {};

if (!data.firstName || data.firstName.trim().length === 0) {
errors.firstName = ['First name is required'];
} else if (data.firstName.length > 100) {
errors.firstName = ['First name must be less than 100 characters'];
}

if (!data.lastName || data.lastName.trim().length === 0) {
errors.lastName = ['Last name is required'];
} else if (data.lastName.length > 100) {
errors.lastName = ['Last name must be less than 100 characters'];
}

if (data.dateOfBirth) {
const birthDate = new Date(data.dateOfBirth);
const today = new Date();
const age = today.getFullYear() - birthDate.getFullYear();

if (age < 13) {
errors.dateOfBirth = ['You must be at least 13 years old'];
}
}

if (data.phone && !/^\+[1-9]\d{1,14}$/.test(data.phone.replace(/[\s()-]/g, ''))) {
errors.phone = ['Please enter a valid phone number with country code'];
}

return {
isValid: Object.keys(errors).length === 0,
errors
};
};

export const prepareRegistrationData = (formData) => {
const payload = {
// Required fields
username: formData.username.trim(),
email: formData.email.trim().toLowerCase(),
password: formData.password,
password_confirmation: formData.passwordConfirmation,
first_name: formData.firstName.trim(),
last_name: formData.lastName.trim()
};

// Optional fields - only include if provided
if (formData.userType) {
payload.user_type = formData.userType;
}

if (formData.dateOfBirth) {
payload.date_of_birth = formData.dateOfBirth; // YYYY-MM-DD format
}

if (formData.phone) {
payload.phone = formData.phone.trim();
}

if (formData.country) {
payload.country = formData.country;
}

if (formData.state) {
payload.state = formData.state;
}

if (formData.city) {
payload.city = formData.city.trim();
}

if (formData.zipcode) {
payload.zipcode = formData.zipcode.trim();
}

return payload;
};

// Debounce utility for real-time validation
export const debounce = (func, delay) => {
let timeoutId;
return (...args) => {
clearTimeout(timeoutId);
timeoutId = setTimeout(() => func.apply(null, args), delay);
};
};

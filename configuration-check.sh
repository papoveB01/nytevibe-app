// Frontend Data Format Debugger for nYtevibe Registration
// Add this to your registration form to debug exactly what's being sent

const debugRegistrationData = async (formData) => {
  console.log('🔍 FRONTEND DATA DEBUG SESSION');
  console.log('=====================================');
  
  // 1. Log the raw form data your frontend receives
  console.log('📝 RAW FORM DATA:');
  console.log(formData);
  console.log('Type:', typeof formData);
  console.log('Constructor:', formData.constructor.name);
  
  // 2. Show the WORKING format from your cURL test
  const WORKING_FORMAT = {
    username: "debugtest123",
    email: "debug@example.com",
    password: "password123", 
    password_confirmation: "password123",
    first_name: "Debug",
    last_name: "Test"
  };
  
  console.log('✅ KNOWN WORKING FORMAT:');
  console.log(JSON.stringify(WORKING_FORMAT, null, 2));
  
  // 3. Convert your form data to the expected API format
  let apiPayload;
  
  // Check if formData is FormData object
  if (formData instanceof FormData) {
    console.log('📋 Converting FormData to object...');
    apiPayload = {};
    for (let [key, value] of formData.entries()) {
      apiPayload[key] = value;
      console.log(`FormData: ${key} = ${value}`);
    }
  } 
  // Check if it's a regular object
  else if (typeof formData === 'object') {
    console.log('📋 Processing object data...');
    apiPayload = { ...formData };
  } 
  else {
    console.error('❌ Unexpected form data type:', typeof formData);
    return;
  }
  
  // 4. Map frontend field names to API field names
  const fieldMapping = {
    // Frontend field names → API field names
    'firstName': 'first_name',
    'lastname': 'last_name', 
    'lastName': 'last_name',
    'passwordConfirmation': 'password_confirmation',
    'confirmPassword': 'password_confirmation',
    'userType': 'user_type',
    'dateOfBirth': 'date_of_birth',
    'phoneNumber': 'phone',
    'zipCode': 'zipcode',
    'postalCode': 'zipcode'
  };
  
  console.log('🔄 FIELD MAPPING CHECK:');
  Object.keys(apiPayload).forEach(key => {
    if (fieldMapping[key]) {
      console.log(`Mapping: ${key} → ${fieldMapping[key]}`);
      apiPayload[fieldMapping[key]] = apiPayload[key];
      delete apiPayload[key];
    }
  });
  
  // 5. Clean and validate the payload
  const finalPayload = {};
  
  // Required fields - these MUST be present
  const requiredFields = ['username', 'email', 'password', 'password_confirmation', 'first_name', 'last_name'];
  
  console.log('✅ REQUIRED FIELDS CHECK:');
  requiredFields.forEach(field => {
    if (apiPayload[field] && apiPayload[field].toString().trim() !== '') {
      finalPayload[field] = apiPayload[field].toString().trim();
      console.log(`✅ ${field}: "${finalPayload[field]}"`);
    } else {
      console.error(`❌ Missing required field: ${field}`);
    }
  });
  
  // Optional fields - only include if they have values
  const optionalFields = ['user_type', 'date_of_birth', 'phone', 'country', 'state', 'city', 'zipcode'];
  
  console.log('📋 OPTIONAL FIELDS CHECK:');
  optionalFields.forEach(field => {
    if (apiPayload[field] && apiPayload[field].toString().trim() !== '') {
      finalPayload[field] = apiPayload[field].toString().trim();
      console.log(`✅ ${field}: "${finalPayload[field]}"`);
    } else {
      console.log(`⚪ ${field}: (not provided)`);
    }
  });
  
  // 6. Show final payload vs working format
  console.log('📤 FINAL PAYLOAD TO SEND:');
  console.log(JSON.stringify(finalPayload, null, 2));
  
  console.log('🔍 PAYLOAD COMPARISON:');
  console.log('Your payload keys:', Object.keys(finalPayload).sort());
  console.log('Working payload keys:', Object.keys(WORKING_FORMAT).sort());
  
  // Check for differences
  const yourKeys = new Set(Object.keys(finalPayload));
  const workingKeys = new Set(Object.keys(WORKING_FORMAT));
  
  const extraKeys = [...yourKeys].filter(x => !workingKeys.has(x));
  const missingKeys = [...workingKeys].filter(x => !yourKeys.has(x));
  
  if (extraKeys.length > 0) {
    console.warn('⚠️ EXTRA FIELDS (might cause validation errors):', extraKeys);
  }
  
  if (missingKeys.length > 0) {
    console.error('❌ MISSING REQUIRED FIELDS:', missingKeys);
  }
  
  // 7. Test the actual API call
  console.log('🚀 TESTING API CALL...');
  
  try {
    const response = await fetch('https://system.nytevibe.com/api/auth/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Origin': 'https://blackaxl.com'
      },
      body: JSON.stringify(finalPayload)
    });
    
    const responseData = await response.json();
    
    console.log('📡 API RESPONSE:');
    console.log('Status:', response.status, response.statusText);
    console.log('Response data:', responseData);
    
    if (response.status === 422) {
      console.error('❌ VALIDATION ERRORS:');
      console.error(responseData.errors);
      
      // Show which fields failed validation
      if (responseData.errors) {
        Object.keys(responseData.errors).forEach(field => {
          console.error(`❌ ${field}:`, responseData.errors[field]);
        });
      }
    } else if (response.status === 201) {
      console.log('🎉 SUCCESS! Registration worked!');
      return { success: true, data: responseData };
    } else {
      console.error('❌ Unexpected response:', response.status);
    }
    
  } catch (error) {
    console.error('🚨 NETWORK ERROR:', error);
  }
  
  // 8. Recommendations
  console.log('💡 DEBUGGING RECOMMENDATIONS:');
  console.log('1. Check if field names match exactly (underscore vs camelCase)');
  console.log('2. Ensure password and password_confirmation are identical');
  console.log('3. Remove any empty or undefined fields');
  console.log('4. Check for extra fields not in the API specification');
  console.log('5. Verify data types (strings, not numbers/booleans)');
  
  return { success: false, payload: finalPayload };
};

// Usage in your registration form:
// const result = await debugRegistrationData(yourFormData);

// Also add this simple test function:
const testWithKnownWorkingData = async () => {
  console.log('🧪 Testing with exact working data from cURL...');
  
  const workingData = {
    username: `frontend_test_${Date.now()}`,
    email: `frontend_test_${Date.now()}@example.com`,
    password: "password123",
    password_confirmation: "password123", 
    first_name: "Frontend",
    last_name: "Test"
  };
  
  return await debugRegistrationData(workingData);
};

// Call this to test: testWithKnownWorkingData();

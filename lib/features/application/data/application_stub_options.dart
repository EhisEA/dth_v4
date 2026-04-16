/// Stub lists until API/static JSON assets exist.
abstract final class ApplicationStubOptions {
  static const List<String> genders = ['Male', 'Female', 'Prefer not to say'];

  static const List<String> nigerianStates = [
    'Lagos',
    'Abuja',
    'Rivers',
    'Kano',
    'Oyo',
    'Enugu',
  ];

  static const Map<String, List<String>> citiesByState = {
    'Lagos': ['Ikeja', 'Lekki', 'Surulere', 'Victoria Island'],
    'Abuja': ['Garki', 'Wuse', 'Maitama', 'Gwarinpa'],
    'Rivers': ['Port Harcourt', 'Bonny', 'Eleme'],
    'Kano': ['Nasarawa', 'Fagge', 'Dala'],
    'Oyo': ['Ibadan North', 'Ibadan South-East', 'Akinyele'],
    'Enugu': ['Enugu North', 'Enugu South', 'Nsukka'],
  };

  static const Map<String, List<String>> lgasByState = {
    'Lagos': ['Ikeja', 'Eti-Osa', 'Surulere', 'Kosofe'],
    'Abuja': ['Abaji', 'Gwagwalada', 'Municipal'],
    'Rivers': ['Port Harcourt', 'Obio-Akpor', 'Eleme'],
    'Kano': ['Kano Municipal', 'Fagge', 'Dala'],
    'Oyo': ['Ibadan North', 'Akinyele', 'Egbeda'],
    'Enugu': ['Enugu North', 'Enugu South', 'Nkanu West'],
  };

  static const List<String> campuses = [
    'Lagos — Ikeja hub',
    'Abuja — Central hub',
    'Port Harcourt hub',
    'Enugu hub',
    'Online / Remote',
  ];

  static const List<String> talentCategories = [
    'Spoken Word',
    'Music',
    'Dance',
    'Comedy',
    'Acting',
    'Other',
  ];

  static const List<String> presentationModes = ['Individual', 'Group'];

  static const List<String> crewSizes = [
    '2 Persons',
    '3 Persons',
    '4 Persons',
    '5 Persons',
    '6+ Persons',
  ];

  static const List<String> banks = [
    'United Bank for Africa',
    'Access Bank',
    'GTBank',
    'First Bank of Nigeria',
    'Zenith Bank',
    'Fidelity Bank',
  ];
}

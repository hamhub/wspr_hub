export const toCamel = (s: string) => {
  return s.replace(/([-_][a-z])/gi, $1 => {
    return $1
      .toUpperCase()
      .replace('-', '')
      .replace('_', '');
  });
};

export const transformGraphQLErrors = errors => {
  // Map the field errors.
  const formErrors = errors.reduce((fe, e) => {
    if (e.field) {
      fe[toCamel(e.field)] = e.message;
    }

    return fe;
  }, {});

  return formErrors;
};

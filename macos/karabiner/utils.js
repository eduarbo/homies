const from = (key, mandatory, optional = ['any']) => ({
  key_code: key,
  modifiers: {
    mandatory,
    optional,
  },
});

const to = (keys) => keys.map(([key, modifiers]) => ({
  key_code: key,
  modifiers,
}));

const manipulator = (options) => ({
  type: 'basic',
  ...options,
});

// `modTap` acts like a modifier when held, and a regular keycode when tapped. In
// other words, you can have a key that sends Escape when you tap it, but
// functions as a Control or Shift key when you hold it down.
const keyToString = (...args) => args.map(([key, modifiers = []]) => [
  modifiers.length && `${modifiers.join('+')}+`,
  key,
].filter(Boolean).join('')).join(' | ');

const remap = (fromKey, toKey, options) => ({
  description: `${keyToString(fromKey)} to ${keyToString(...toKey)}`,
  type: 'basic',
  from: from(...fromKey),
  to: to(toKey),
  ...options,
});

const remap2 = (fromKey, toKey, { layer, ...options } = {}) => ({
  description: `${keyToString(fromKey)} to ${keyToString(...toKey)}`,
  type: 'basic',
  from: from(...fromKey),
  // to: to(toKey),
  to: [
    ...to(toKey),
    ...(layer ? [{
      to_after_key_up: [
        {
          set_variable: {
            name: layer,
            value: 0,
          },
        },
      ],
    }] : []),
  ],
  // ...(layer && {
  //   conditions: [{
  //     type: 'variable_if',
  //     name: layer,
  //     value: 1,
  //   }],
  // }),
  ...options,
});

const remapSticky = (sticky, fromKey, toKey, options = {}) => {
  const { to: remapTo, ...remapProps } = remap(fromKey, toKey);

  return {
    ...remapProps,
    to: [
      {
        set_variable: {
          name: sticky,
          value: 1,
        },
      },
      ...remapTo,
    ],
    to_delayed_action: {
      to_if_invoked: [
        {
          set_variable: {
            name: sticky,
            value: 0,
          },
        },
      ],
      to_if_canceled: [
        {
          set_variable: {
            name: sticky,
            value: 1,
          },
        },
      ],
    },
    ...options,
  };
};

const modTap = (fromKey, toKey, toKeyOnTap, options) => ({
  ...remap(fromKey, toKey, options),
  description: `${keyToString(fromKey)} to ${keyToString(...toKey)}, send ${keyToString(...toKeyOnTap)} on tap`,
  to_if_alone: to(toKeyOnTap),
});

const getRules = (mods) => mods.reduce((rules, mod) => {
  // when rules are passed in the form: [qwerty, ['thumbCluster', 'customQwerty']]
  if (Array.isArray(mod)) {
    const [modification, modRules] = mod;
    return rules.concat(modification.rules.filter((rule) => modRules.includes(rule.id)));
  }

  return rules.concat(mod.rules);
}, []);

const profile = (name, mods = [], overrides = {}) => ({
  name,
  devices: [],
  virtual_hid_keyboard: {
    caps_lock_delay_milliseconds: 0,
    country_code: 0,
    keyboard_type: '',
  },
  ...overrides,
  complex_modifications: {
    parameters: {
      'basic.simultaneous_threshold_milliseconds': 50,
      'basic.to_delayed_action_delay_milliseconds': 500,
      'basic.to_if_alone_timeout_milliseconds': 1000,
      'basic.to_if_held_down_threshold_milliseconds': 500,
    },
    rules: getRules(mods),
    ...overrides.complex_modifications,
  },
});

module.exports = {
  from,
  manipulator,
  modTap,
  profile,
  remap,
  remap2,
  remapSticky,
  to,
};

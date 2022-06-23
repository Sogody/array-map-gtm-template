___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Array Map",
  "categories": ["UTILITY"],
  "description": "This template transforms an array of values (or objects) to another array of objects.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "array",
    "displayName": "Array",
    "simpleValueType": true,
    "help": "This is the input array"
  },
  {
    "type": "PARAM_TABLE",
    "name": "result",
    "displayName": "",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "key",
          "displayName": "Key",
          "simpleValueType": true
        },
        "isUnique": true
      },
      {
        "param": {
          "type": "TEXT",
          "name": "valuePath",
          "displayName": "Value or Path",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "CHECKBOX",
          "name": "constantValue",
          "checkboxText": "Constant",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "CHECKBOX",
          "name": "stringify",
          "checkboxText": "Stringify the resulting value",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');

function objectKeys(obj) {
    var keys = [];
    for (var name in obj) {
        if (obj.hasOwnProperty(name)) {
            keys.push(name);
        }
    }

    return keys;
}

function mergeObjects(array) {
    return array.reduce(function (r, o) {
        objectKeys(o).forEach(function (k) {
            r[k] = o[k];
        });
        return r;
    }, {});
}

function getValueByPath(obj, path) {
    return path.split('.').reduce(function (o, k) {
        var ind = k.indexOf('[');
        var ind2 = k.indexOf(']');
        if (ind >= 0 && ind2 > ind) {
            var kOrg = k;
            k = kOrg.substring(0, ind);
            var key = kOrg.substring(ind + 1, ind2);
            if (k != "")
                return o && o[k][key];
            else
                return o && o[key];
        } else return o && o[k];
    }, obj);
}

var array = data.array || [];
if (typeof (array) === "string") array = JSON.parse(array);

return array.map(function (elm) {
    return mergeObjects(data.result.map(function (obj) {
        var result = {};
      
        result[obj.key] = obj.constantValue ? obj.valuePath : getValueByPath(elm, obj.valuePath);

        if (obj.stringify) {
            result[obj.key] = "" + result[obj.key];
        }

        return result;
    }));
});


___TESTS___

scenarios:
- name: Transforms the array of objects to the desired result
  code: |-
    const mockData = {
      array: [{quantity: 2, id: 32456}],
      result: [
        { key: "qty", valuePath: "quantity"},
        { key: "sku", valuePath: "id"}
      ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].qty).isEqualTo(2);
    assertThat(variableResult[0].sku).isEqualTo(32456);
- name: Parses the array if it is stringified
  code: |-
    const mockData = {
      array: '[{"quantity":2,"id":32456}]',
      result: [
        { key: "qty", valuePath: "quantity"},
        { key: "sku", valuePath: "id"}
      ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].qty).isEqualTo(2);
    assertThat(variableResult[0].sku).isEqualTo(32456);
- name: Optionally stringifies values
  code: |-
    const mockData = {
      array: [{quantity: 2, id: 32456}],
      result: [
        { key: "qty", valuePath: "quantity"},
        { key: "sku", valuePath: "id", stringify: "true"}
      ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].qty).isEqualTo(2);
    assertThat(variableResult[0].sku).isEqualTo("32456");
- name: Allows specification of constant values
  code: |-
    const mockData = {
      array: [{quantity: 2, id: 32456}],
      result: [
        { key: "qty", valuePath: "quantity"},
        { key: "sku", valuePath: "id", stringify: true },
        { key: "content_type", valuePath: "product", constantValue: true },
      ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].content_type).isEqualTo("product");


___NOTES___

Created on 6/23/2022, 2:16:54 PM



import axios from 'axios';

function convert() {
  const convertButton = document.getElementById('convert');
  const updateButton = document.getElementById('update');
  const answer = document.getElementById('answer');

  convertButton.addEventListener('click', () => {
    const input = document.getElementById('input');
    const [from, to] = extractUnits(document.getElementById('units').value);

    let conversion = { value: input.value, from, to };

    if (input.value) {
      axios.get('/api/convert', { params: conversion })
        .then(r => answer.innerHTML = `${input.value} ${from} is ${r.data.answer} ${to}`)
        .catch(r => console.log(r));
    }
  });

  updateButton.addEventListener('click', () => {
    axios.get('/api/update-conversions')
      .then(r => {
        const unitSelect = document.getElementById('units');
        removeChildNodes(unitSelect);
        r.data.conversions.forEach(c => createOption(c, unitSelect));
      });
  });

  answer.addEventListener('click', () => {
    answer.innerHTML = '';
  });
}

function extractUnits(string) {
  return string
    .toLowerCase()
    .split(' ')
    .filter(x => x !== 'to');
}

function createOption(optionValue, selectParent) {
  const opt = document.createElement('option');
  opt.value = optionValue;
  opt.innerHTML = optionValue
  selectParent.appendChild(opt);
}

function removeChildNodes(parent) {
  while (parent.firstChild) {
    parent.removeChild(parent.firstChild);
  }
}

convert();

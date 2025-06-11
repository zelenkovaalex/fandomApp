function purchaseTrail(trailId) {
  fetch('/purchases', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify({ trail_id: trailId })
  })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
    });
}
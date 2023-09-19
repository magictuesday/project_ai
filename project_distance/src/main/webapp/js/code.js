const geocodingApiKey = "AIzaSyAW9bQ2ZQSPHGTssVKNWorabBJyp6Y8HaI";
const distanceMatrixApiKey = "AIzaSyAW9bQ2ZQSPHGTssVKNWorabBJyp6Y8HaI";

const originsAddress = "<%= originsAddress %>";
const destinationsAddress = "<%= destinationsAddress %>";

async function getGeocode(address) {
  const geocodingUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${geocodingApiKey}`;
  const response = await fetch(geocodingUrl);
  const data = await response.json();
  
  if (data.status === "OK") {
    const location = data.results[0].geometry.location;
    return [location.lat, location.lng];
  } else {
    return null;
  }
}

async function main() {
  const origins = await getGeocode(originsAddress);
  const destinations = await getGeocode(destinationsAddress);

  if (origins && destinations) {
    const mode = "transit";
    const baseUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?";
    
    const url = `${baseUrl}origins=${origins[0]},${origins[1]}&destinations=${destinations[0]},${destinations[1]}&mode=${mode}&key=${distanceMatrixApiKey}`;
    
    const response = await fetch(url);
    const data = await response.json();
    
    if (data.status === "OK") {
      const distance = data.rows[0].elements[0].distance.text;
      const duration = data.rows[0].elements[0].duration.text;
      console.log(`거리: ${distance}`);
      // console.log(`소요 시간: ${duration}`);
    } else {
      console.log("거리 및 시간 정보를 가져오지 못했습니다.");
    }
  } else {
    console.log("좌표를 가져오지 못했습니다.");
  }
}

main();

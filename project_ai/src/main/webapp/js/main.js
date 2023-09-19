async function loadImageBase64(file) {
	return new Promise((resolve, reject) => {
		const reader = new FileReader();
		reader.readAsDataURL(file);
		reader.onload = () => resolve(reader.result);
		reader.onerror = (error) => reject(error);
	});
}

const classPrices = {};

goodsData.forEach(item => {
    classPrices[item.name] = item.price;
});

document.getElementById("uploadButton").addEventListener("click", async () => {
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];
    const resultContainer = document.getElementById("resultContainer");

    if (!file) {
        alert("이미지 파일을 선택해주세요.");
        return;
    }

    try {
        const image = await loadImageBase64(file);

        const response = await axios({
            method: "POST",
            url: "https://detect.roboflow.com/appliance-vbmjz/1",
            params: {
                api_key: "xWix8kvq3rK2f2b3ljxR"
            },
            data: image,
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            }
        });

        const classValues = response.data.predictions.map(prediction => prediction.class);

        const classCount = {};
        let totalPrice = 0;

        classValues.forEach(classValue => {
            if (classCount[classValue]) {
                classCount[classValue]++;
            } else {
                classCount[classValue] = 1;
            }
            totalPrice += classPrices[classValue] || 0;
        });

        let resultHTML = "<p>종류 및 가격:</p><ul>";
        for (const className in classCount) {
            const classPrice = classPrices[className] || 0;
            const classTotalPrice = classPrice * classCount[className];
            resultHTML += `<li>${className}: ${classCount[className]}, ${classTotalPrice}원</li>`;
        }
        resultHTML += "</ul>";
        resultHTML += `<p>총 가격 : ${totalPrice}원</p>`;

        resultContainer.innerHTML = resultHTML;
    } catch (error) {
        console.error(error.message);
    }
});

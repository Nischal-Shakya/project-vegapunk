// const url = 'https://7148-111-119-49-209.in.ngrok.io';
// const url = 'http://192.168.100.172:8000';
// const url = 'http://192.168.101.165:8000';

//pp number = 699-526-518-7
//mob number =9851228881

const url = 'http://192.168.100.54:8000';
const wsUrl = 'ws://192.168.100.54:8000';
// const url = 'http://192.168.1.70:8000';
// const wsUrl = 'ws://192.168.1.70:8000';
const getDataUrl = '$url/api/v1/identity/documents/';
const postMobileAndNinUrl = '$url/api/v1/auth/';
const postOtp = '$url/api/v1/auth/verify/';
const getDataQrUrl = '$url/api/v1/qr/request';
const getPermitIdUrl = '$wsUrl/ws/qr/permit';
const getPidDataUrl = '$url/api/v1/qr/permit';
const scanRequestApprovalUrl = '$url/api/v1/scan-request';

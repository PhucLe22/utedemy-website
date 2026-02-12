document.addEventListener('DOMContentLoaded', function() {
    // Date picker
    const birthdateInput = document.getElementById('birthdate');
    birthdateInput.addEventListener('focus', function() {
        this.type = 'date';
    });
    birthdateInput.addEventListener('blur', function() {
        if (!this.value) {
            this.type = 'text';
        }
    });
});

function previewFile() {
    const preview = document.getElementById('previewImage');
    const placeholder = document.getElementById('placeholder');
    const fileInput = document.getElementById('images1');
    const file = fileInput.files[0];

    if (file) {
        const reader = new FileReader();
        reader.onloadend = function() {
            preview.src = reader.result;
            preview.style.display = '';
            if (placeholder) {
                placeholder.style.display = 'none';
            }
        };
        reader.readAsDataURL(file);
    }
}

function redirectToHomepage() {
    const contextPath = document.querySelector('form').action.split('/user/')[0];
    window.location.href = contextPath + '/user/homepage';
}

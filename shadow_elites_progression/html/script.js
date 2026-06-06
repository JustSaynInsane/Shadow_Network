// ============================================
// SHADOW NETWORK - APP LOGIC
// Week 2 expansion coming soon
// ============================================

console.log('Shadow Network App - Week 1 Foundation');

// Hide UI on load
document.body.style.display = 'none';

// Week 2 will add:
// - Real-time progression display
// - Heist activation buttons
// - Crew management
// - Laundering tracker
// - Black market shop

// Show/Hide UI functions
function showUI() {
    document.body.style.display = 'block';
}

function hideUI() {
    document.body.style.display = 'none';
    // Tell Lua to close
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function closeUI() {
    hideUI();
}

// Listen for messages from Lua
window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.action === 'openShadowNetwork') {
        showUI();
        console.log('Shadow Network opened');
    } else if (data.action === 'closeShadowNetwork') {
        hideUI();
        console.log('Shadow Network closed');
    }
});

// Close on ESC key
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeUI();
    }
});
// ==UserScript==
// @name         AI Interview Assistant - DEBUG
// @namespace    http://tampermonkey.net/
// @version      3.0
// @description  AI interview feedback with debugging
// @author       Your Name
// @match        *://*/*
// @grant        GM_addStyle
// @grant        GM_getValue
// @grant        GM_setValue
// @grant        GM_deleteValue
// @grant        GM_listValues
// @grant        unsafeWindow
// ==/UserScript==

(function() {
    'use strict';
    
    console.log('=== AI Interview Assistant Starting ===');
    console.log('URL:', window.location.href);
    
    // First, let's check if Tampermonkey is working
    if (typeof GM_addStyle === 'undefined') {
        console.error('Tampermonkey functions not available!');
        alert('Please make sure Tampermonkey is properly installed and enabled.');
        return;
    }
    
    // Wait for page to load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAssistant);
    } else {
        setTimeout(initAssistant, 1000);
    }
    
    function initAssistant() {
        console.log('Initializing Assistant...');
        
        // Check if already injected
        if (document.getElementById('interview-assistant-btn')) {
            console.log('Assistant already exists');
            return;
        }
        
        // Add CSS first
        addStyles();
        
        // Create and inject UI
        createFloatingButton();
        createMainPanel();
        
        // Add test message to verify it's working
        console.log('✅ Assistant injected successfully!');
        
        // Also add a visible test indicator
        addTestIndicator();
    }
    
    function addTestIndicator() {
        const testDiv = document.createElement('div');
        testDiv.id = 'tampermonkey-test';
        testDiv.innerHTML = '🎤 AI Assistant Loaded';
        testDiv.style.cssText = `
            position: fixed;
            top: 10px;
            left: 10px;
            background: #10b981;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            z-index: 999999;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        `;
        
        // Add pulsing animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0% { opacity: 1; }
                50% { opacity: 0.7; }
                100% { opacity: 1; }
            }
        `;
        document.head.appendChild(style);
        
        document.body.appendChild(testDiv);
        
        // Remove after 5 seconds
        setTimeout(() => {
            testDiv.remove();
        }, 5000);
    }
    
    function addStyles() {
        const css = `
            /* Floating Button */
            #interview-assistant-btn {
                position: fixed !important;
                right: 20px !important;
                bottom: 20px !important;
                width: 60px !important;
                height: 60px !important;
                background: #3b82f6 !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                font-size: 28px !important;
                cursor: pointer !important;
                z-index: 2147483647 !important; /* Maximum z-index */
                box-shadow: 0 4px 20px rgba(59, 130, 246, 0.5) !important;
                border: 2px solid white !important;
                transition: all 0.3s ease !important;
            }
            
            #interview-assistant-btn:hover {
                transform: scale(1.1) !important;
                box-shadow: 0 6px 25px rgba(59, 130, 246, 0.7) !important;
                background: #2563eb !important;
            }
            
            /* Main Panel */
            #interview-assistant-panel {
                position: fixed !important;
                right: 90px !important;
                bottom: 20px !important;
                width: 450px !important;
                height: 600px !important;
                background: white !important;
                border-radius: 12px !important;
                box-shadow: 0 10px 40px rgba(0,0,0,0.3) !important;
                z-index: 2147483646 !important;
                display: none !important;
                overflow: hidden !important;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif !important;
                border: 1px solid #e5e7eb !important;
            }
            
            .assistant-header {
                background: linear-gradient(90deg, #3b82f6, #8b5cf6) !important;
                color: white !important;
                padding: 15px 20px !important;
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
            }
            
            .assistant-header h3 {
                margin: 0 !important;
                font-size: 16px !important;
                font-weight: 600 !important;
            }
            
            .close-btn {
                background: none !important;
                border: none !important;
                color: white !important;
                font-size: 24px !important;
                cursor: pointer !important;
                line-height: 1 !important;
                padding: 0 !important;
                width: 24px !important;
                height: 24px !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
            }
            
            .close-btn:hover {
                opacity: 0.8 !important;
            }
            
            .assistant-body {
                padding: 20px !important;
                height: calc(100% - 130px) !important;
                overflow-y: auto !important;
            }
            
            /* Rest of styles similar to previous version */
            .question-section, .feedback-section, .questions-list-section, .history-section {
                margin-bottom: 20px !important;
                padding-bottom: 20px !important;
                border-bottom: 1px solid #e5e7eb !important;
            }
            
            h4 {
                margin: 0 0 10px 0 !important;
                color: #1f2937 !important;
                font-size: 14px !important;
                font-weight: 600 !important;
            }
            
            .current-question {
                background: #f9fafb !important;
                padding: 12px !important;
                border-radius: 8px !important;
                margin-bottom: 10px !important;
                font-size: 14px !important;
                line-height: 1.5 !important;
                border: 1px solid #e5e7eb !important;
            }
            
            .custom-question {
                width: 100% !important;
                padding: 10px !important;
                border: 1px solid #d1d5db !important;
                border-radius: 8px !important;
                resize: vertical !important;
                font-size: 14px !important;
                font-family: inherit !important;
                margin-top: 10px !important;
            }
            
            .feedback-display {
                background: #f0f9ff !important;
                padding: 15px !important;
                border-radius: 8px !important;
                margin-bottom: 15px !important;
                font-size: 13px !important;
                line-height: 1.6 !important;
                min-height: 80px !important;
                border: 1px solid #bae6fd !important;
            }
            
            .thumbs-container {
                display: flex !important;
                gap: 15px !important;
                justify-content: center !important;
                margin: 15px 0 !important;
            }
            
            .thumb-btn {
                width: 50px !important;
                height: 50px !important;
                border-radius: 50% !important;
                border: none !important;
                font-size: 20px !important;
                cursor: pointer !important;
                transition: all 0.2s !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
            }
            
            .thumb-btn:hover {
                transform: scale(1.1) !important;
            }
            
            .thumb-btn.positive {
                background: #10b981 !important;
                color: white !important;
            }
            
            .thumb-btn.negative {
                background: #ef4444 !important;
                color: white !important;
            }
            
            .questions-list, .history-list {
                max-height: 120px !important;
                overflow-y: auto !important;
                background: #f9fafb !important;
                border-radius: 6px !important;
                padding: 5px !important;
                border: 1px solid #e5e7eb !important;
            }
            
            .question-item, .history-item {
                padding: 8px 10px !important;
                margin: 4px 0 !important;
                background: white !important;
                border-radius: 4px !important;
                font-size: 13px !important;
                cursor: pointer !important;
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
                border: 1px solid transparent !important;
            }
            
            .question-item:hover, .history-item:hover {
                background: #f3f4f6 !important;
                border-color: #d1d5db !important;
            }
            
            .question-status {
                font-size: 11px !important;
                padding: 3px 8px !important;
                border-radius: 4px !important;
                font-weight: 600 !important;
            }
            
            .status-positive {
                background: #d1fae5 !important;
                color: #065f46 !important;
            }
            
            .status-negative {
                background: #fee2e2 !important;
                color: #991b1b !important;
            }
            
            .status-pending {
                background: #fef3c7 !important;
                color: #92400e !important;
            }
            
            .assistant-footer {
                padding: 15px 20px !important;
                background: #f9fafb !important;
                display: flex !important;
                gap: 10px !important;
                justify-content: flex-end !important;
                border-top: 1px solid #e5e7eb !important;
            }
            
            .action-btn {
                padding: 8px 16px !important;
                border: 1px solid #d1d5db !important;
                border-radius: 6px !important;
                background: white !important;
                cursor: pointer !important;
                font-size: 13px !important;
                font-weight: 500 !important;
                transition: all 0.2s !important;
            }
            
            .action-btn:hover {
                background: #f9fafb !important;
            }
            
            .action-btn.primary {
                background: #3b82f6 !important;
                color: white !important;
                border: none !important;
            }
            
            .action-btn.primary:hover {
                background: #2563eb !important;
            }
        `;
        
        GM_addStyle(css);
        console.log('✅ Styles injected');
    }
    
    function createFloatingButton() {
        const button = document.createElement('div');
        button.id = 'interview-assistant-btn';
        button.innerHTML = '🎤';
        button.title = 'AI Interview Assistant (Click to open)';
        
        // Make sure it's absolutely visible
        button.style.cssText = `
            position: fixed !important;
            right: 20px !important;
            bottom: 20px !important;
            width: 60px !important;
            height: 60px !important;
            background: #3b82f6 !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 28px !important;
            cursor: pointer !important;
            z-index: 2147483647 !important;
            box-shadow: 0 4px 20px rgba(59, 130, 246, 0.5) !important;
            border: 2px solid white !important;
        `;
        
        button.addEventListener('click', togglePanel);
        document.body.appendChild(button);
        console.log('✅ Floating button created');
    }
    
    function createMainPanel() {
        const panel = document.createElement('div');
        panel.id = 'interview-assistant-panel';
        panel.innerHTML = `
            <div class="assistant-header">
                <h3>🤖 AI Interview Assistant</h3>
                <button class="close-btn" title="Close">×</button>
            </div>
            <div class="assistant-body">
                <div class="question-section">
                    <h4>Current Question:</h4>
                    <div class="current-question" id="current-question">
                        No question selected. Click on any question on the page or type below.
                    </div>
                    <textarea class="custom-question" placeholder="Or type your question here..." rows="3"></textarea>
                </div>
                
                <div class="feedback-section">
                    <h4>AI Feedback:</h4>
                    <div class="feedback-display" id="ai-feedback">
                        Select a question and click thumbs up/down for AI feedback
                    </div>
                    <div class="thumbs-container">
                        <button class="thumb-btn positive" title="Good response">👍</button>
                        <button class="thumb-btn negative" title="Needs improvement">👎</button>
                    </div>
                </div>
                
                <div class="questions-list-section">
                    <h4>Detected Questions:</h4>
                    <div class="questions-list" id="questions-list">
                        <div class="question-item">
                            <span>Scanning page for questions...</span>
                        </div>
                    </div>
                </div>
                
                <div class="history-section">
                    <h4>Response History:</h4>
                    <div class="history-list" id="history-list">
                        <div class="history-item">
                            <span>No feedback given yet</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="assistant-footer">
                <button class="action-btn" id="clear-history">Clear History</button>
                <button class="action-btn primary" id="export-feedback">Export Feedback</button>
            </div>
        `;
        
        document.body.appendChild(panel);
        console.log('✅ Main panel created');
        
        // Add event listeners
        setupEventListeners();
        scanForQuestions();
    }
    
    function setupEventListeners() {
        // Close button
        document.querySelector('#interview-assistant-panel .close-btn').addEventListener('click', closePanel);
        
        // Thumb buttons
        document.querySelector('.thumb-btn.positive').addEventListener('click', () => generateFeedback('positive'));
        document.querySelector('.thumb-btn.negative').addEventListener('click', () => generateFeedback('negative'));
        
        // Custom question input
        document.querySelector('.custom-question').addEventListener('input', function(e) {
            const question = e.target.value.trim();
            if (question) {
                selectQuestion(question);
            }
        });
        
        // Action buttons
        document.getElementById('clear-history').addEventListener('click', clearHistory);
        document.getElementById('export-feedback').addEventListener('click', exportFeedback);
        
        console.log('✅ Event listeners setup');
    }
    
    let isPanelOpen = false;
    
    function togglePanel() {
        console.log('Toggle panel called');
        const panel = document.getElementById('interview-assistant-panel');
        isPanelOpen = !isPanelOpen;
        panel.style.display = isPanelOpen ? 'block' : 'none';
        
        if (isPanelOpen) {
            scanForQuestions();
        }
    }
    
    function closePanel() {
        document.getElementById('interview-assistant-panel').style.display = 'none';
        isPanelOpen = false;
    }
    
    function selectQuestion(question) {
        document.getElementById('current-question').textContent = question;
        console.log('Question selected:', question.substring(0, 50) + '...');
    }
    
    function generateFeedback(type) {
        const currentQuestion = document.getElementById('current-question').textContent;
        if (!currentQuestion || currentQuestion.includes('No question selected')) {
            alert('Please select or type a question first!');
            return;
        }
        
        const feedbacks = {
            positive: [
                "Your response demonstrates excellent clarity with practical examples that showcase real-world application. Consider expanding on metrics for measurable impact.",
                "Strong technical foundation evident in your systematic approach. The logical structure and depth show comprehensive understanding of core concepts.",
                "Exceptional problem-solving methodology with creative yet practical solutions. Your analytical thinking provides solid frameworks for implementation.",
                "Impressive communication skills demonstrated through clear explanations. The audience-aware approach ensures effective knowledge transfer.",
                "Notable leadership perspective showing balanced decision-making. Your strategic thinking combines innovation with practical constraints effectively."
            ],
            negative: [
                "Response would benefit from more specific examples demonstrating practical application. Incorporate measurable outcomes to strengthen credibility.",
                "Technical concepts need clearer explanation tailored to diverse audiences. Simplify language while maintaining technical accuracy for better comprehension.",
                "Problem-solving approach appears theoretical rather than applied. Include specific methodologies and real-world results to demonstrate effectiveness.",
                "Depth of knowledge requires expansion with current industry standards. Reference emerging technologies to show updated expertise.",
                "Communication strategy needs more audience customization. Different stakeholders require varied approaches and detail levels for optimal engagement."
            ]
        };
        
        const feedback = feedbacks[type][Math.floor(Math.random() * feedbacks[type].length)];
        document.getElementById('ai-feedback').textContent = feedback;
        
        // Update history
        updateHistory(currentQuestion, type, feedback);
        
        console.log('Feedback generated:', type);
    }
    
    function updateHistory(question, type, feedback) {
        const historyList = document.getElementById('history-list');
        const item = document.createElement('div');
        item.className = 'history-item';
        item.innerHTML = `
            <span>${question.substring(0, 40)}${question.length > 40 ? '...' : ''}</span>
            <span class="question-status status-${type}">
                ${type === 'positive' ? '👍' : '👎'}
            </span>
        `;
        
        if (historyList.firstChild && historyList.firstChild.textContent.includes('No feedback')) {
            historyList.innerHTML = '';
        }
        
        historyList.prepend(item);
    }
    
    function scanForQuestions() {
        console.log('Scanning for questions...');
        const questionsList = document.getElementById('questions-list');
        
        // Clear loading message
        if (questionsList.innerHTML.includes('Scanning')) {
            questionsList.innerHTML = '';
        }
        
        // Look for questions
        const elements = document.querySelectorAll('h1, h2, h3, h4, p, li, .question, [class*="question"], [id*="question"]');
        let foundCount = 0;
        
        elements.forEach(el => {
            const text = el.textContent.trim();
            if (text.length > 20 && text.length < 200 && text.includes('?')) {
                const item = document.createElement('div');
                item.className = 'question-item';
                item.innerHTML = `
                    <span>${text.substring(0, 60)}${text.length > 60 ? '...' : ''}</span>
                    <span class="question-status status-pending">?</span>
                `;
                
                item.addEventListener('click', () => {
                    selectQuestion(text);
                    el.scrollIntoView({ behavior: 'smooth', block: 'center' });
                });
                
                questionsList.appendChild(item);
                foundCount++;
                
                if (foundCount >= 10) return;
            }
        });
        
        if (foundCount === 0) {
            questionsList.innerHTML = '<div class="question-item"><span>No questions found. Type your own above.</span></div>';
        }
        
        console.log(`Found ${foundCount} questions`);
    }
    
    function clearHistory() {
        document.getElementById('history-list').innerHTML = 
            '<div class="history-item"><span>No feedback given yet</span></div>';
        document.getElementById('ai-feedback').textContent = 'History cleared';
    }
    
    function exportFeedback() {
        alert('Export functionality would be implemented here!\nIn a full version, this would download all feedback as a text file.');
    }
    
    // Initial test
    console.log('=== AI Interview Assistant Ready ===');
    console.log('Look for the blue 🎤 button in bottom-right corner');
})();
// TermsAndConditions.jsx
import React, { useEffect } from 'react';
import './TermsAndConditions.css';

const TermsAndConditions = () => {
  useEffect(() => {
    // Scroll to top when component mounts
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="terms-container">
      <div className="terms-header">
        <div className="terms-logo">
          <h1>nYtevibe</h1>
        </div>
        <a href="/" className="back-link">← Back to Home</a>
      </div>
      
      <div className="terms-content">
        <h1 className="terms-title">nYtevibe Terms and Conditions</h1>
        
        <div className="terms-meta">
          <p><strong>Effective Date</strong>: January 1, 2025</p>
          <p><strong>Last Updated</strong>: January 1, 2025</p>
        </div>

        <div className="terms-sections">
          <section>
            <h2>1. Acceptance of Terms</h2>
            
            <p><strong>1.1</strong> Welcome to nYtevibe! These Terms and Conditions ("Terms") form a legally binding agreement between you and nYtevibe, Inc. ("Company," "we," "us," or "our") regarding your use of our nightlife discovery platform, website, mobile application, and related services (collectively, the "Platform").</p>
            
            <p><strong>1.2</strong> By creating an account, accessing, or using our Platform, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy, which is incorporated herein by reference.</p>
            
            <p><strong>1.3</strong> If you do not agree to these Terms, you must not use our Platform.</p>
            
            <p><strong>1.4</strong> We may update these Terms from time to time. Your continued use of the Platform after changes are posted constitutes acceptance of the revised Terms.</p>
          </section>

          <section>
            <h2>2. Eligibility and Account Requirements</h2>
            
            <p><strong>2.1 Age Requirement</strong>: You must be at least 18 years old to use our Platform. By using our Platform, you represent that you are at least 18 years old and have the legal capacity to enter into binding agreements.</p>
            
            <p><strong>2.2 Geographic Restrictions</strong>: Our Platform is intended for users in jurisdictions where nightlife discovery services are legal. You are responsible for compliance with local laws.</p>
            
            <p><strong>2.3 Account Registration</strong>: To access certain features, you must:</p>
            <ul>
              <li>Provide accurate, complete, and current information</li>
              <li>Maintain and update your account information</li>
              <li>Keep your login credentials confidential</li>
              <li>Accept responsibility for all activities under your account</li>
            </ul>
            
            <p><strong>2.4 One Account Per Person</strong>: You may maintain only one personal account. Creating multiple accounts may result in termination of all accounts.</p>
          </section>

          <section>
            <h2>3. Platform Services</h2>
            
            <p><strong>3.1 Core Services</strong>: nYtevibe provides:</p>
            <ul>
              <li>Venue discovery and search functionality</li>
              <li>User-generated reviews and ratings</li>
              <li>Event listings and information</li>
              <li>Social networking features</li>
              <li>Venue booking and reservation services (where available)</li>
              <li>Premium subscription features</li>
            </ul>
            
            <p><strong>3.2 Third-Party Services</strong>: Our Platform may integrate with third-party services (payment processors, mapping services, etc.). Your use of such services is subject to their respective terms and conditions.</p>
            
            <p><strong>3.3 Service Availability</strong>: We strive to maintain continuous service availability but do not guarantee uninterrupted access. We may modify, suspend, or discontinue services with or without notice.</p>
          </section>

          <section>
            <h2>4. User Conduct and Community Guidelines</h2>
            
            <p><strong>4.1 General Conduct</strong>: You agree to:</p>
            <ul>
              <li>Use the Platform lawfully and respectfully</li>
              <li>Provide honest and accurate information</li>
              <li>Respect other users' rights and privacy</li>
              <li>Comply with all applicable laws and regulations</li>
            </ul>
            
            <p><strong>4.2 Prohibited Activities</strong>: You may not:</p>
            <ul>
              <li>Create fake accounts or impersonate others</li>
              <li>Submit false, misleading, or fraudulent reviews</li>
              <li>Post spam, promotional content, or unauthorized advertising</li>
              <li>Upload harmful code, viruses, or malicious software</li>
              <li>Harass, threaten, or abuse other users</li>
              <li>Violate intellectual property rights</li>
              <li>Use automated systems to access or scrape our Platform</li>
              <li>Attempt to circumvent security measures</li>
              <li>Engage in illegal activities or promote illegal conduct</li>
            </ul>
            
            <p><strong>4.3 Review Guidelines</strong>: When posting reviews, you must:</p>
            <ul>
              <li>Base reviews on genuine personal experiences</li>
              <li>Provide honest and constructive feedback</li>
              <li>Avoid inappropriate language or personal attacks</li>
              <li>Not accept compensation for reviews without disclosure</li>
              <li>Respect venue staff and other patrons' privacy</li>
            </ul>
          </section>

          <section>
            <h2>5. Content and Intellectual Property</h2>
            
            <p><strong>5.1 User-Generated Content</strong>: You retain ownership of content you submit ("User Content") but grant us certain rights as outlined below.</p>
            
            <p><strong>5.2 License Grant</strong>: By submitting User Content, you grant nYtevibe a worldwide, non-exclusive, royalty-free, perpetual, irrevocable license to:</p>
            <ul>
              <li>Use, reproduce, modify, and distribute your content</li>
              <li>Display your content on our Platform and in marketing materials</li>
              <li>Create derivative works based on your content</li>
              <li>Sublicense these rights to third parties as necessary for Platform operation</li>
            </ul>
            
            <p><strong>5.3 Content Standards</strong>: All User Content must:</p>
            <ul>
              <li>Be original or properly licensed</li>
              <li>Comply with applicable laws</li>
              <li>Not infringe on others' rights</li>
              <li>Meet our community guidelines</li>
              <li>Be appropriate for a diverse, global audience</li>
            </ul>
            
            <p><strong>5.4 Content Monitoring</strong>: We reserve the right to:</p>
            <ul>
              <li>Monitor, review, and moderate User Content</li>
              <li>Remove content that violates these Terms</li>
              <li>Refuse publication of any content</li>
              <li>Take action against violating accounts</li>
            </ul>
            
            <p><strong>5.5 Platform Content</strong>: All content on our Platform (excluding User Content) is owned by nYtevibe or licensed to us. You may not copy, distribute, modify, or create derivative works without permission.</p>
          </section>

          <section>
            <h2>6. Premium Services and Payments</h2>
            
            <p><strong>6.1 Subscription Services</strong>: We offer premium subscription plans with enhanced features. Subscription terms, pricing, and billing cycles are specified during signup.</p>
            
            <p><strong>6.2 Payment Terms</strong>:</p>
            <ul>
              <li>Subscriptions are billed in advance on a recurring basis</li>
              <li>All fees are non-refundable unless required by law</li>
              <li>You authorize us to charge your payment method automatically</li>
              <li>Price changes will be communicated 30 days in advance</li>
            </ul>
            
            <p><strong>6.3 Cancellation</strong>: You may cancel subscriptions at any time through your account settings. Cancellations take effect at the end of the current billing period.</p>
            
            <p><strong>6.4 Points System</strong>: Our boost points system allows additional promotional features:</p>
            <ul>
              <li>Points are purchased separately from subscriptions</li>
              <li>Points expire according to stated terms</li>
              <li>Points are non-refundable and non-transferable</li>
              <li>Point values and pricing may change with notice</li>
            </ul>
          </section>

          <section>
            <h2>7. Privacy and Data Protection</h2>
            
            <p><strong>7.1 Data Collection</strong>: We collect and process personal information as described in our Privacy Policy.</p>
            
            <p><strong>7.2 Location Data</strong>: Our Platform may access location information to provide relevant venue recommendations. You can control location sharing through device settings.</p>
            
            <p><strong>7.3 Communications</strong>: By using our Platform, you consent to receive communications from us, including service announcements, promotional messages, and administrative notices.</p>
            
            <p><strong>7.4 Data Security</strong>: We implement reasonable security measures to protect your information but cannot guarantee absolute security.</p>
          </section>

          <section>
            <h2>8. Disclaimers and Limitations</h2>
            
            <p><strong>8.1 Service Availability</strong>: Our Platform is provided "as is" and "as available." We disclaim all warranties, express or implied, including warranties of merchantability and fitness for a particular purpose.</p>
            
            <p><strong>8.2 User Content Disclaimer</strong>: We do not endorse or guarantee the accuracy of User Content, including reviews and ratings. Users rely on such content at their own risk.</p>
            
            <p><strong>8.3 Third-Party Venues</strong>: We are not responsible for the quality, safety, or legality of venues listed on our Platform. Users interact with venues at their own risk.</p>
            
            <p><strong>8.4 Limitation of Liability</strong>: To the maximum extent permitted by law, nYtevibe shall not be liable for:</p>
            <ul>
              <li>Indirect, incidental, or consequential damages</li>
              <li>Loss of profits, data, or business opportunities</li>
              <li>Damages exceeding the amount paid to us in the 12 months preceding the claim</li>
            </ul>
          </section>

          <section>
            <h2>9. Indemnification</h2>
            
            <p>You agree to indemnify, defend, and hold harmless nYtevibe, its officers, directors, employees, and agents from any claims, losses, damages, or expenses (including attorney fees) arising from:</p>
            <ul>
              <li>Your use of the Platform</li>
              <li>Your violation of these Terms</li>
              <li>Your User Content</li>
              <li>Your violation of others' rights</li>
            </ul>
          </section>

          <section>
            <h2>10. Termination</h2>
            
            <p><strong>10.1 Termination by You</strong>: You may terminate your account at any time by contacting customer support or using account deletion features.</p>
            
            <p><strong>10.2 Termination by Us</strong>: We may terminate or suspend your account immediately for:</p>
            <ul>
              <li>Violation of these Terms</li>
              <li>Suspected fraudulent activity</li>
              <li>Extended periods of inactivity</li>
              <li>Legal or regulatory requirements</li>
            </ul>
            
            <p><strong>10.3 Effect of Termination</strong>: Upon termination:</p>
            <ul>
              <li>Your access to the Platform will cease</li>
              <li>Some User Content may remain on the Platform</li>
              <li>Certain provisions of these Terms will survive termination</li>
            </ul>
          </section>

          <section>
            <h2>11. Dispute Resolution</h2>
            
            <p><strong>11.1 Governing Law</strong>: These Terms are governed by the laws of the State of Texas, United States, without regard to conflict of law principles.</p>
            
            <p><strong>11.2 Arbitration</strong>: Any disputes arising from these Terms or your use of the Platform shall be resolved through binding arbitration administered by the American Arbitration Association (AAA) under its Commercial Arbitration Rules.</p>
            
            <p><strong>11.3 Class Action Waiver</strong>: You agree to resolve disputes individually and waive the right to participate in class actions or collective proceedings.</p>
            
            <p><strong>11.4 Jurisdiction</strong>: For matters not subject to arbitration, courts in Austin, Texas shall have exclusive jurisdiction.</p>
          </section>

          <section>
            <h2>12. Miscellaneous Provisions</h2>
            
            <p><strong>12.1 Entire Agreement</strong>: These Terms, together with our Privacy Policy, constitute the entire agreement between you and nYtevibe.</p>
            
            <p><strong>12.2 Severability</strong>: If any provision of these Terms is found unenforceable, the remaining provisions will remain in full force and effect.</p>
            
            <p><strong>12.3 Waiver</strong>: Our failure to enforce any provision does not constitute a waiver of that provision or any other provision.</p>
            
            <p><strong>12.4 Assignment</strong>: You may not assign these Terms without our written consent. We may assign these Terms at any time.</p>
            
            <p><strong>12.5 Force Majeure</strong>: We are not liable for delays or failures caused by circumstances beyond our reasonable control.</p>
            
            <p><strong>12.6 Electronic Communications</strong>: You consent to receive agreements and notices electronically.</p>
          </section>

          <section>
            <h2>13. Contact Information</h2>
            
            <p>For questions about these Terms or our Platform, please contact us:</p>
            
            <div className="contact-info">
              <p><strong>nYtevibe, Inc.</strong><br />
              Email: legal@nytevibe.com<br />
              Address: [Company Address]<br />
              Phone: [Phone Number]</p>
              
              <p><strong>Customer Support</strong>:<br />
              Email: support@nytevibe.com<br />
              Hours: Monday-Friday, 9 AM - 6 PM CST</p>
            </div>
          </section>

          <section>
            <h2>14. Special Provisions</h2>
            
            <p><strong>14.1 Venue Partners</strong>: Special terms may apply to venue partners and business accounts. Such terms will be provided separately and supplement these Terms.</p>
            
            <p><strong>14.2 Beta Features</strong>: We may offer beta or experimental features. These are provided without warranty and may be discontinued at any time.</p>
            
            <p><strong>14.3 International Users</strong>: Users outside the United States may be subject to additional terms based on local laws and regulations.</p>
            
            <p><strong>14.4 Age Verification</strong>: We may require age verification for certain features or jurisdictions. False verification information may result in account termination.</p>
          </section>
        </div>

        <div className="terms-footer">
          <p><strong>By using nYtevibe, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.</strong></p>
          <p><em>These Terms are effective as of the date first written above and supersede all previous versions.</em></p>
        </div>
      </div>
    </div>
  );
};

export default TermsAndConditions;
